class ReservationsController < ApplicationController

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def check_availability
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(reservation_params)
    @reservation.room = @room
    if @reservation.valid?
      @total_value = @reservation.total_value
      flash.now[:notice] = "Reserva disponível"
      return render :check_availability
    end
    flash.now[:alert] = "Reserva não disponível"
    render :new
  end

  
  private

  def reservation_params
    params.require(:reservation).permit(:checkin, :checkout, :number_of_guests, :room_id)
  end
end