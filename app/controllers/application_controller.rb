class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers
  include Pundit
  protect_from_forgery with: :exception, prepend: true
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected    
  
    def current_user
      @current_user ||= authenticate_by_session(User)
    end

    def require_user!
      return if current_user
      redirect_to root_path, flash: { error: 'You must be authenticated to access this resource' }
    end

    def user_not_authorized(exception)
      message = exception.reason ? "pundit.errors.#{e.reason}" : exception.policy ? "#{exception.policy.class.to_s.underscore}.#{exception.query}" : e.message

      flash[:error] = I18n.t(message, scope: "pundit", default: :default)

      redirect_to(request.referrer || root_path)
    end
end
