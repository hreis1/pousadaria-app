class RatesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :authenticate_owner!, only: [:index]

  def index
    @rates = current_owner.inn.rates.order(created_at: :desc)
  end

  def create
    @reservation = Reservation.find(params[:reservation_id])
    rate_params = params.require(:rate).permit(:rating, :review)
    @rate = Rate.new(rate_params)
    @rate.reservation = @reservation
    if @rate.save
      redirect_to user_reservation_path(@reservation), notice: "Avaliação enviada com sucesso!"
    else
      redirect_to user_reservation_path(@reservation), alert: "Não foi possível realizar a avaliação"
    end
  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update(params.require(:rate).permit(:response))
    if @rate.save
      redirect_to reservation_rates_path(@rate.reservation)
    else
      redirect_to reservation_rates_path(@rate.reservation), alert: "Não foi possível enviar a resposta"
    end
  end
end