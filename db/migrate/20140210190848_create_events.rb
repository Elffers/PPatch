class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :time
      t.string :venue
      t.text :description
      t.string :name
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end
end
