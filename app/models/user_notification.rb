class UserNotification < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  class << self
    def create_or_error(notification_id:, user_id:)
      new_record = UserNotification.new
      new_record.user_id = user_id
      new_record.notification_id = notification_id
      new_record.sent_at = DateTime.now
      if new_record.valid?
        new_record.save
        return true, new_record
      else
        return false, new_record.errors
      end
    end

    def destroy_old_records(record_array:)
      UserNotification.where.not(id: record_array.pluck(:id)).destroy_all
    end
  end
end
