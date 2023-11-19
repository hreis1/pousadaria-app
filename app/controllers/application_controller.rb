class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end

  private
  
  def check_owner
    @room = Room.find(params[:room_id])
    if current_owner != @room.inn.owner
      redirect_to root_path, alert: "Você não tem autorização para acessar essa página"
    end
  end
end
