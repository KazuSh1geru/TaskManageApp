class CreateCreatives < ActiveRecord::Migration[6.1]
  def change
    create_table :creatives do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :name, limit: 100, null: false
      t.timestamps
    end
  end
end