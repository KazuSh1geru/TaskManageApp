class Project < ApplicationRecord
  validates :name, presence: true, length: {maximum: 10},
            uniqueness: {case_sensitive: false }
  belongs_to :user
  has_many :creatives
end
