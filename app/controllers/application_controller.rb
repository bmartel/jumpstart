class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :client_state

  protected    
  
    def authenticate_admin_user!
      authenticate_user!
      unless current_user.admin?
        flash[:alert] = "Unauthorized Access!"
        redirect_to root_path
      end
    end

    def layout_by_resource
      if devise_controller?
        "base"
      else
        "application"
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
end
