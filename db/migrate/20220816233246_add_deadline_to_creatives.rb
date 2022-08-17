class AddDeadlineToCreatives < ActiveRecord::Migration[6.1]
  def change
    add_column :creatives, :deadline, :date
  end
end
