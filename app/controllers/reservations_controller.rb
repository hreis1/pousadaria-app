class ReservationsController < ApplicationController
  before_action :authenticate_owner!, only: [:index, :cancel, :checkin]
  before_action :authenticate_user!, only: [:create]
  
  def index
    @reservations = current_owner.inn.reservations
  end
  
  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def check
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.build(reservation_params)
    if @reservation.valid?
      @total_value = @reservation.total_value
      flash.now[:notice] = "Reserva disponível"
      return render :check
    end
    flash.now[:alert] = "Reserva não disponível"
    render :new
  end
  
  def create
    @room = Room.find(params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      flash[:notice] = "Reserva efetuada com sucesso"
      redirect_to user_reservations_path
    else
      flash.now[:alert] = "Não foi possível efetuar a reserva"
      render :new
    end
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    if @reservation.owner == current_owner && @reservation.status == "pending" && @reservation.checkin < 2.days.from_now
      @reservation.canceled!
      return redirect_to reservations_path, notice: "Reserva cancelada com sucesso"
    end
    flash.now[:alert] = "Não foi possível cancelar a reserva"
    redirect_to reservations_path
  end

  def checkin
    @reservation = Reservation.find(params[:id])
    if @reservation.pending? && @reservation.checkin.to_date <= Time.zone.today
      @reservation.active!
      if @reservation.save
        return redirect_to reservation_path(@reservation), notice: "Check-in realizado com sucesso"
      end
    end
    flash[:alert] = "Não foi possível realizar o check-in"
    redirect_to reservation_path(@reservation)
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
        return redirect_to reservations_path, notice: "Check-out realizado com sucesso"
      end
    end
    flash[:alert] = "Não foi possível realizar o check-out"
    redirect_to reservations_path(@reservation)
  end

  def active_stays
    @reservations = current_owner.inn.reservations.active
    render :index
  end
  

  private

  def reservation_params
    params.require(:reservation).permit(:checkin, :checkout, :number_of_guests, :room_id)
  end
end