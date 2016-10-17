class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  protect_from_forgery
  skip_before_action :verify_authenticity_token

  #Activar permisos para agregar campos Nombre y apellidos en la creaciom de usuario
    before_filter :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters
        	devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name, :email, :password, :current_password])
            devise_parameter_sanitizer.permit(:account_update, keys: [:name, :last_name, :email, :password, :current_password])
        end
    #
end
