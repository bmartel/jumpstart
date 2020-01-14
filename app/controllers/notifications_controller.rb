class NotificationsController < ApplicationController
  layout "base"
  before_action :authenticate_user!

  def index
    @notifications = policy_scope(Notification)
  end
end
