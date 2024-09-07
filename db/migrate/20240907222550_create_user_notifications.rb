class CreateUserNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :user_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notification, null: false, foreign_key: true
      t.timestamp :sent_at
    end
  end
end
