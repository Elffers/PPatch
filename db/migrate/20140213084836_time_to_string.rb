class TimeToString < ActiveRecord::Migration
  def change
    change_column :events, :time, :string
  end
end
