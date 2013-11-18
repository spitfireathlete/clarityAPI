class Project < ActiveRecord::Base  
  belongs_to :user
  belongs_to :priority
  has_many :collaborators, :through => :collaborations, :source => :user
  has_many :ideas
end
