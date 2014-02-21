class AddPreferencesAsHstore < ActiveRecord::Migration
  def change
    add_column :users, :preferences, :hstore
  end
end
