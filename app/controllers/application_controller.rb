class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

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
