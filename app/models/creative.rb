class Creative < ApplicationRecord
  belongs_to :project
  validates :name, presence: true, length: {maximum: 10}    
  validates :deadline, presence: true
  has_many :tasks
end
