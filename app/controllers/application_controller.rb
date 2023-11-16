class ApplicationController < ActionController::Base


  private
  
  def check_owner
    @room = Room.find(params[:room_id])
    if current_owner != @room.inn.owner
      redirect_to root_path, alert: "Você não tem autorização para acessar essa página"
    end
  end
end
