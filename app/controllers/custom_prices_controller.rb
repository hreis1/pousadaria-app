class CustomPricesController < ApplicationController
  before_action :authenticate_owner!
  before_action :check_owner

  def new
    @room = Room.find(params[:room_id])
    @custom_price = CustomPrice.new
  end

  def create
    @room = Room.find(params[:room_id])
    @custom_price = CustomPrice.new(custom_price_params)
    @custom_price.room = @room
    if @custom_price.save
      redirect_to inn_room_path(@room.inn, @room), notice: "Preço personalizado cadastrado com sucesso!"
    else
      render :new
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @custom_price = @room.custom_prices.find(params[:id])
    if @custom_price.destroy
      return redirect_to inn_path(@room.inn), notice: "Preço personalizado apagado com sucesso!"
    else
      flash[:alert] = "Não foi possível apagar o preço personalizado"
      return redirect_to inn_path(@room.inn)
    end
  end

  private

  def custom_price_params
    params.require(:custom_price).permit(:start_date, :end_date, :price)
  end
end