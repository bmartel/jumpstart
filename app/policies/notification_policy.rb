class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(recipient: user)
    end
  end
end

