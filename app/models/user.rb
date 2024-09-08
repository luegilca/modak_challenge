class User < ApplicationRecord
  has_many :user_notifications
  has_many :notifications, :through => :user_notifications
end
