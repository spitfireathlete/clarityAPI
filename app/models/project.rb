class Project < ActiveRecord::Base  
  belongs_to :user
  has_many :collaborators, :through => :collaborations, :source => :user
end
