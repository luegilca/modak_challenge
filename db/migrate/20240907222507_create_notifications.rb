class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :notification_type
      t.integer :frequency
      t.integer :interval
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
