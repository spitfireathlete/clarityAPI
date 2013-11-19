class TokensController  < ApplicationController

    skip_before_filter :verify_authenticity_token
    respond_to :json
    
    def create
    email = params[:email]
    
    client = Restforce.new :oauth_token => auth_params[:sf_oauth_token],
      :instance_url  => auth_params[:instance_url]
      
      response = client.authenticate!

      info = client.get(response.id).body
      puts info
      user_id = info.user_id
      


      if @user.nil?
        logger.info("Failed signin, user cannot be found.")
        render :status=>401, :json=>{:message=>"Invalid credentials."}
        return
      end
    
      if not @user.valid_password?(password)
        logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
        render :status=>401, :json=>{:message=>"Invalid email or password."}
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
    

    def auth_params
      params.require(:token).permit(:sf_oauth_token, :identity_url, :instance_url)
    end
 
end