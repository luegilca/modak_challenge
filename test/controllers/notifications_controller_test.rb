require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification = notifications(:one)
  end

  test "should get index" do
    get get_all_notifications_path
    assert_response :success
  end

  test "should create notification" do
    assert_difference("Notification.count") do
      post create_notifications_path, params: { notification: { notification_type: "test", frequency: 1, interval: 2, active: false } }
    end

    assert_response :created
  end

  test "should show notification" do
    get get_notifications_path(@notification)
    assert_response :success
  end

  test "should update notification" do
    patch update_notifications_path(@notification), params: { notification: { notification_type: "edited", frequency: 1, interval: 2, active: true } }
    assert_response :success
  end

  test "should destroy notification" do
    assert_difference("Notification.count", -1) do
      delete destroy_notifications_path(@notification)
    end

    assert_response :no_content
  end
end
