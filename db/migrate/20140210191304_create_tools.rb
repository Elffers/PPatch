class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :name
      t.text :description
      t.boolean :checkedin

      t.timestamps
    end
  end
end
