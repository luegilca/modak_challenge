class ChangeColumnIntervalFromUsers < ActiveRecord::Migration[7.1]
  def up
    change_column :notifications, :interval, :bigint
  end

  def down
    change_column :notifications, :interval, :integer
  end
end
