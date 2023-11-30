class UserReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :cancel]
  before_action :set_reservation, only: [:show, :cancel, :rate]

  def index
    @reservations = current_user.reservations.order(checkin: :asc)
  end

  def show
    @rate = @reservation.rate || Rate.new
  end

  def cancel
    if current_user == @reservation.user && @reservation.status == "pending" && @reservation.checkin > 7.days.from_now
      @reservation.canceled!
      redirect_to user_reservations_path, notice: "Reserva cancelada com sucesso"
    else
      redirect_to root_path, alert: "Não foi possível cancelar a reserva"
    end
  end


  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def user_rate_params
    params.require(:reservation).permit(:rating, :review)
  end
end