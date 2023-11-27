class UserReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :cancel]

  def index
    @reservations = current_user.reservations.order(checkin: :asc)
  end

  def show
    @reservation = Reservation.find(params[:id])
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

  def rate
    @reservation = Reservation.find(params[:id])
    if current_user == @reservation.user && @reservation.finished? && @reservation.rating.nil?
      if @reservation.update(user_rate_params)
        redirect_to user_reservation_path(@reservation), notice: "Avaliação enviada com sucesso!"
      end
    else
      redirect_to user_reservation_path(@reservation), alert: "Não foi possível realizar a avaliação"
    end
  end

  private

  def user_rate_params
    params.require(:reservation).permit(:rating, :review)
  end
end