class User < ActiveRecord::Base
  require 'securerandom'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
         
         has_many :accessible_projects, :through => :collaborations, :source => :project
         has_many :projects
         
  before_save :ensure_authentication_token
  
  
  def self.from_mobile_facebook_access_token(token)
    fb_user = FbGraph::User.me(token)
    fb_user = fb_user.fetch
    if !fb_user.nil?
      where({:fb_uid => fb_user.identifier}).first_or_initialize.tap do |user|
        user.fb_uid = fb_user.identifier
        user.password = SecureRandom.hex(10)
        user.email = fb_user.email
        user.first_name = fb_user.first_name
        user.last_name = fb_user.last_name
        user.save!
      end
    end
  end
  
  
end
