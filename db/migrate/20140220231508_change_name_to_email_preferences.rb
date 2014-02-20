class ChangeNameToEmailPreferences < ActiveRecord::Migration
  def change
    rename_column :users, :preferences, :email_preferences
  end
end
