class Task < ApplicationRecord
    validates :name, presence: true, length: {maximum: 20}    
    validates :status, length: {maximum: 20}    
    belongs_to :user
end
