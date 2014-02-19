class EmailPreferenceDefault < ActiveRecord::Migration
  def change
    change_column :users, :preferences, :boolean, default: true
  end
end
