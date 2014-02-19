class EmailPreferences < ActiveRecord::Migration
  def change
    add_column :users, :preferences, :boolean
  end
end
