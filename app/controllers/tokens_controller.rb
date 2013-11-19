class TokensController  < ApplicationController
  require "net/http"
  require "uri"
  require 'securerandom'

    skip_before_filter :verify_authenticity_token
    respond_to :json
    
    def create
      
      # can exchange Facebook token for auth token
      if not auth_params[:mobile_facebook_token].nil?
            begin
            @user = User.from_mobile_facebook_access_token(auth_params[:mobile_facebook_token])
            if not @user.persisted?
              logger.info("Failed signin, user cannot be created or found.")
              render :status=>401, :json=>{:message=>"Invalid credentials."}
              return
            end
          rescue FbGraph::InvalidToken
            logger.info("Invalid facebook token provided")
            render :status=>401, :json=>{:message=>"Invalid Facebook token provided."}
            return
          end
        end
      
        # otherwise exchange Salesforce oauth token for auth token
      begin
      response = fetch(auth_params[:identity_url])
      
      if response.code == '200' then
        parsed_json = ActiveSupport::JSON.decode(response.body)
        email = parsed_json['email']
        first_name = parsed_json['first_name']
        last_name = parsed_json['last_name']
      
        @user = User.where(:email => email).first_or_initialize
        @user.first_name = first_name
        @user.last_name = last_name 
        @user.password = SecureRandom.hex(10) 
        @user.save!
        
      end
      
           
      rescue Net::HTTPServerException
        logger.info("Invalid credentials provided")
        render :status=>401, :json=>{:message=>"Invalid credentials"}
        return
      end

      if @user.nil?
        logger.info("Failed signin, user cannot be found.")
        render :status=>401, :json=>{:message=>"Invalid credentials."}
        return
      end
    
      # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
      @user.ensure_authentication_token!
 
      render :status=>200, :json=>{:token=>@user.authentication_token,
        :email => @user.email,
      }
      
    end
  
  
 
  def destroy
    find_user_by_token
    
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end
  
  private
    
    def find_user_by_token
      @user=User.find_by_authentication_token(params[:id])
    end
    
    def fetch(uri_str, limit = 10)
      # poor man's client for the salesforce API
      # just want to check the ouath-token, don't need a full featured client
      # apparently salesforce redirects you a bunch of times
    
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      url = URI.parse(uri_str)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
    
      req = Net::HTTP::Get.new(url.request_uri)
      req["Authorization"] = "OAuth " + auth_params[:sf_oauth_token]  
    
      response = http.start { |http| 
        http.request(req) 
      }
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
      
    end
    

    def auth_params
      params.require(:token).permit(:sf_oauth_token, :identity_url, :mobile_facebook_token)
    end
 
end