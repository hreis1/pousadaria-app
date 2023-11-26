class UserReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :cancel]

  def index
    @reservations = current_user.reservations.order(checkin: :asc)
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    if current_user == @reservation.user && @reservation.status == "pending" && @reservation.checkin > 7.days.from_now
      @reservation.canceled!
      redirect_to user_reservations_path, notice: "Reserva cancelada com sucesso"
    else
      redirect_to root_path, alert: "Não foi possível cancelar a reserva"
    end
  end
end