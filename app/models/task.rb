class Task < ApplicationRecord
    validates :name, presence: true, length: {maximum: 20}    
    validates :status, length: {maximum: 20}    
    belongs_to :user
    belongs_to :creative
    belongs_to :project

    enum task_status: {
        todo: 0,
        doing: 1,
        done: 2,
    }
end
