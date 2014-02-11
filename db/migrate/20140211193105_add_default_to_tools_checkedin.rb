class AddDefaultToToolsCheckedin < ActiveRecord::Migration
  def change
    change_column :tools, :checkedin, :boolean, default: true
  end
end
