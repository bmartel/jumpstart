class AnnouncementPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(published_at: 1.year.ago...)
      end
    end
  end
end
