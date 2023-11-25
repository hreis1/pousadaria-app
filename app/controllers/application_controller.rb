class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :inn_registration, if: :owner_signed_in?

  before_action :store_user_location!, if: :storable_location?
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  protected
  
  def inn_registration
    return if current_owner.inn

    exempt_actions = ['sessions#destroy', 'inns#new', 'inns#create']

    redirect_to new_inn_path, alert: "Você precisa cadastrar uma pousada para continuar." unless exempt_actions.include?("#{controller_name}##{action_name}")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end

  private

  def check_owner(inn_id)
    @inn = Inn.find(inn_id)
    if current_owner != @inn.owner
      redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
  end
end
