class ChangeTimeAndDateEvents < ActiveRecord::Migration
  def change
    change_column :events, :time, :time
    add_column :events, :date, :date

  end
end
