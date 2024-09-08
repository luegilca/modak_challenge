class NotificationService
  include NotificationsInterface

  #override
  def send(type:, user_id:, message:)
    notification = Notification.by_notification_type(type: type)
    unless is_rate_limited(notification: notification, user_id: user_id)
      save_notification(user_id: user_id, notification: notification)
      dispatch_message(user_id: user_id, notification: notification, message: message)
      return true
    end
    return false
  end

  def is_rate_limited(notification:, user_id:)
    unless notification && notification.active
      return false
    end

    now = Time.zone.now
    notifications_sent_to_user = UserNotification.where(user_id: user_id).where(notification: notification)
    time_filter = -> record { ( (now - record.sent_at) / 1.second ).to_i <= notification.interval }
    latest_sent_in_interval = notifications_sent_to_user.select(&time_filter)

    # Destroy records that are outside of time interval
    UserNotification.destroy_old_records(record_array: latest_sent_in_interval)

    return latest_sent_in_interval.size >= notification.frequency
  end

  def save_notification(user_id:, notification:)
    status, data = UserNotification.create_or_error(notification_id: notification.id, user_id: user_id)
    if status
      Rails.logger.info("Notification successfully created with id #{data.id}")
    else
      Rails.logger.error("Notification cannot be created because: #{data.to_json}")
    end
    return status
  end

  def dispatch_message(user_id:, notification:, message:)
    #TODO: Connect with notifications provider
    Rails.logger.info("Sending message: #{message} of type #{notification.notification_type} to recipient #{user_id}")
  end
end