class AddUserIdToTools < ActiveRecord::Migration
  def change
    add_column :tools, :user_id, :integer
  end
end
