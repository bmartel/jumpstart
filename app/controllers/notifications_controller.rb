class NotificationsController < ApplicationController
  layout "base"
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
  end
end
