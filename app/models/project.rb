class Project < ApplicationRecord
  validates :name, presence: true, length: {maximum: 20}    
  belongs_to :user
  has_many :creatives
  has_many :tasks
end
