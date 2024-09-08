require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @base_notification = notifications(:one)
    @single_frequency_notification = notifications(:two)
    @multiple_frequency_notification = notifications(:three)
    @inactive_frequency_notification = notifications(:four)
    @message_text_sample = "This is just a test"
  end

  def notification_creation_helper(notification_case)
    post create_notifications_path, params: { 
      notification: {
        notification_type: notification_case.notification_type, 
        frequency: notification_case.frequency, 
        interval: notification_case.interval, 
        active: notification_case.active 
      } 
    }
  end

  def send_notification_helper(user_id, type)
    post send_notifications_path, params: { 
        notification: {
          user_id: user_id, 
          type: type, 
          message: @message_text_sample
        } 
      }
  end

  test "should get index" do
    get get_all_notifications_path
    assert_response :success
  end

  test "should create notification" do
    assert_difference("Notification.count") do
      post create_notifications_path, params: { 
        notification: { 
          notification_type: "test", 
          frequency: 1, 
          interval: 2, 
          active: false 
        } 
      }
    end

    assert_response :created
  end

  test "should show notification" do
    get get_notifications_path(@base_notification)
    assert_response :success
  end

  test "should update notification" do
    patch update_notifications_path(@base_notification), params: { 
      notification: { 
        notification_type: "edited", 
        frequency: 1, 
        interval: 2, 
        active: true 
      } 
    }
    assert_response :success
  end

  test "should destroy notification" do
    assert_difference("Notification.count", -1) do
      delete destroy_notifications_path(@base_notification)
    end

    assert_response :no_content
  end

  test "should let create a rate-limited notification" do
    assert_difference("Notification.count") do
      notification_creation_helper(@base_notification)
    end

    assert_response :created
  end

  test "should rate-limit the requests of creating new notifications" do
    assert_difference("Notification.count") do
      notification_creation_helper(@single_frequency_notification)
    end

    assert_response :created
    
    assert_difference("UserNotification.count") do
      send_notification_helper(@user.id, @single_frequency_notification.notification_type)
    end
    assert_response :ok

    assert_no_changes("UserNotification.count") do
      send_notification_helper(@user.id, @single_frequency_notification.notification_type)
    end
    assert_response :internal_server_error
  end

  test "should create notifications after interval time has ellapsed" do
    assert_difference("Notification.count") do
      notification_creation_helper(@multiple_frequency_notification)
    end

    assert_response :created

    assert_difference("UserNotification.count") do
      send_notification_helper(@user.id, @multiple_frequency_notification.notification_type)
    end

    assert_response :ok

    assert_difference("UserNotification.count") do
      send_notification_helper(@user.id, @multiple_frequency_notification.notification_type)
    end

    assert_response :ok

    assert_no_changes("UserNotification.count") do
      send_notification_helper(@user.id, @multiple_frequency_notification.notification_type)
    end

    assert_response :internal_server_error

    # The two seconds threshold is set to guarantee all the records are deleted after execution of send method
    sleep(@multiple_frequency_notification.interval + 2)

    assert_difference("UserNotification.count", -1) do
      send_notification_helper(@user.id, @multiple_frequency_notification.notification_type)
    end

    assert_response :ok
  end

  test "should create notifications even if interval is long because rate limit is inactive" do
    assert_difference("Notification.count") do
      notification_creation_helper(@inactive_frequency_notification)
    end

    assert_response :created

    assert_difference("UserNotification.count") do
      send_notification_helper(@user.id, @inactive_frequency_notification.notification_type)
    end

    assert_response :ok

    assert_difference("UserNotification.count") do
      send_notification_helper(@user.id, @inactive_frequency_notification.notification_type)
    end

    assert_response :ok
  end
end
