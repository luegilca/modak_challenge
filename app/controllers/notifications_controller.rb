class NotificationsController < ApplicationController
  include JsonResponse
  
  def create
    Rails.logger.info("START of service: Sending a notification (POST /notification)")
    service = NotificationService.new
    delivered = service.send(
      type: create_notification_params[:type], 
      user_id: create_notification_params[:user_id], 
      message: create_notification_params[:message]
    )
    if delivered
      Rails.logger.info("Success sending notification")
      general_success("The notification was successfully delivered to recipient")
    else
      Rails.logger.error("There was an error sending the notification")
      general_error("Yoour notification intent was declined due to rate limit")
    end
  end
  private
  
  def create_notification_params
    params.require(:notification).permit(:user_id, :type, :message).tap do |intern_params|
      intern_params.require(:message) && intern_params.require(:user_id) && intern_params.require(:type)
    end
  end 
end
