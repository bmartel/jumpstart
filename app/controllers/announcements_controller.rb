class AnnouncementsController < ApplicationController
  layout "base"
  before_action :mark_as_read, if: :user_signed_in?

  def index
    @announcements = policy_scope(Announcement).order(published_at: :desc)
  end

  private

    def mark_as_read
      current_user.update(announcements_last_read_at: Time.zone.now)
    end
end
