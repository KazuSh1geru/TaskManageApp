class Creative < ApplicationRecord
  validates :name, presence: true, length: {maximum: 20}    
  belongs_to :user
  belongs_to :project
  has_many :tasks
end
