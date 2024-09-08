class NotificationsController < ApplicationController
  include JsonResponse

  before_action :set_notification, only: %i[ show update destroy ]

  def send_notification
    Rails.logger.info("START of service: Sending a notification (POST /notification)")
    service = NotificationService.new
    delivered = service.send(
      type: send_notification_params[:type], 
      user_id: send_notification_params[:user_id], 
      message: send_notification_params[:message]
    )
    if delivered
      Rails.logger.info("Success sending notification")
      general_success("The notification was successfully delivered to recipient")
    else
      Rails.logger.error("There was an error sending the notification")
      general_error("Your notification intent was declined due to rate limit")
    end
  end

  def index
    @notifications = Notification.all
    render json: @notifications
  end

  def show
    render json: @notification
  end

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      render json: @notification, status: :created, location: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification.update(notification_params)
      render json: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @notification.destroy!
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:notification_type, :frequency, :interval, :active).tap do |intern_params|
        intern_params.require(:notification_type) && intern_params.require(:frequency) && 
          intern_params.require(:active)
      end
    end

    def send_notification_params
      params.require(:notification).permit(:user_id, :type, :message).tap do |intern_params|
        intern_params.require(:message) && intern_params.require(:user_id) && intern_params.require(:type)
      end
    end 
end
