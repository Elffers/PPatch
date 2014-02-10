class AddOmniauthValuesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :avatar_url, :string
    add_column :users, :token, :string
    add_column :users, :secret, :string
  end
end

 
