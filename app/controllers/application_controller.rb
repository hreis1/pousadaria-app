class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :inn_registration, if: :owner_signed_in?

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
