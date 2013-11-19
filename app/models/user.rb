class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
         
         has_many :accessible_projects, :through => :collaborations, :source => :project
         has_many :projects
         
  before_save :ensure_authentication_token
end
