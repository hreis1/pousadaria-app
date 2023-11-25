class ReservationsController < ApplicationController
  DAYS_TO_CANCEL_RESERVATION = 7
  before_action :authenticate_user!, only: [:index, :create]
  before_action :authenticate_owner!, only: [:owner_reservations]

  def my_reservations
    @reservations = current_user.reservations
  end

  def owner_reservations
    @reservations = current_owner.inn.reservations
  end

  def owner_reservation
    @reservation = Reservation.find(params[:id])
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(reservation_params)
    @reservation.room = @room
    @reservation.user_id = current_user.id
    if @reservation.save
      flash[:notice] = "Reserva efetuada com sucesso"
      redirect_to my_reservations_path
    else
      flash.now[:alert] = "Não foi possível efetuar a reserva"
      render :new
    end
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

  def cancel_reservation
    @reservation = Reservation.find(params[:id])
    if @reservation.pending? && @reservation.checkin >= DAYS_TO_CANCEL_RESERVATION.days.from_now
      @reservation.canceled!
      return redirect_to my_reservations_path, notice: "Reserva cancelada com sucesso"
    end
    flash[:alert] = "Não foi possível cancelar a reserva"
    redirect_to my_reservations_path
  end

  def checkin
    @reservation = Reservation.find(params[:id])
    if @reservation.pending?
      @reservation.active!
      if @reservation.save
        return redirect_to active_stays_path, notice: "Check-in realizado com sucesso"
      end
    end
    flash[:alert] = "Não foi possível realizar o check-in"
    redirect_to owner_reservations_path(@reservation)
  end

  def checkout
    @reservation = Reservation.find(params[:id])
    @payment_methods = @reservation.room.inn.payment_methods.split(",")
  end

  def finish
    @reservation = Reservation.find(params[:id])
    payment_method = params[:payment_method]
    if @reservation.active?
      @reservation.payment_method = payment_method
      @reservation.amount_paid = @reservation.current_total_value
      @reservation.finished!
      if @reservation.save
        return redirect_to owner_reservations_path, notice: "Check-out realizado com sucesso"
      end
    end
    flash[:alert] = "Não foi possível realizar o check-out"
    redirect_to owner_reservations_path(@reservation)
  end
  
  def cancel
    @reservation = Reservation.find(params[:id])
    if @reservation.pending?
      @reservation.canceled!
      return redirect_to owner_reservations_path, notice: "Reserva cancelada com sucesso"
    end
    flash[:alert] = "Não foi possível cancelar a reserva"
    redirect_to owner_reservations_path
  end

  def active_stays
    @reservations = current_owner.inn.reservations.active
    render :owner_reservations
  end
  
  private

  def reservation_params
    params.require(:reservation).permit(:checkin, :checkout, :number_of_guests, :room_id)
  end
end