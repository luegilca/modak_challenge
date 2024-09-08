class Notification < ApplicationRecord
  has_many :user_notifications

  scope :by_notification_type, -> (type: "") { where("lower(notifications.notification_type) LIKE ?", "%#{type.downcase}%").first }
end
