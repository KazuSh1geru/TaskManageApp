class Task < ApplicationRecord
    validates :name, presence: true, length: {maximum: 20}    
    validates :status, length: {maximum: 20}
    validates :complete, presence: true
    belongs_to :creative

    enum task_status: {
        todo: 0,
        doing: 1,
        done: 2,
    }
end
