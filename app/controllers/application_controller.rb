class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception, prepend: true

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :client_state, unless: :active_admin_controller?
  after_action :verify_authorized, except: :index, if: :app_controller?
  after_action :verify_policy_scoped, only: :index, if: :app_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected    
  
    def active_admin_controller?
      is_a?(ActiveAdmin::BaseController)
    end

    def app_controller?
      !(devise_controller? || active_admin_controller?)
    end

    def authenticate_admin_user!
      authenticate_user!
      unless current_user.admin?
        flash[:alert] = "Unauthorized Access!"
        redirect_to root_path
      end
    end

    def user_not_authorized(exception)
      message = exception.reason ? "pundit.errors.#{e.reason}" : exception.policy ? "#{exception.policy.class.to_s.underscore}.#{exception.query}" : e.message

      flash[:alert] = I18n.t(message, scope: "pundit", default: :default)

      redirect_to(request.referrer || root_path)
    end

    def layout_by_resource
      if app_controller?
        "application"
      else
        "base"
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    def client_state
      @state ||= {}
      @state['csrfToken'] = form_authenticity_token
      @state['auth'] = {}
      @state['alert'] = {}
      @state['alert']['messages'] = flash || [];
      @state['auth']['masquerade'] = user_masquerade?
      @state['auth']['user'] = current_user || {}
    end
  
    # Doorkeeper methods
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
