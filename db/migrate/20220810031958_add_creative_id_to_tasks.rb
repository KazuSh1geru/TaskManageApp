class AddCreativeIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :creative, null: false, foreign_key: true
  end
end
