class SetDefaultForPreferences < ActiveRecord::Migration
  def change
    change_column :users, :preferences, :boolean, default: false
  end
end
