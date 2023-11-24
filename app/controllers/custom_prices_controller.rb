class CustomPricesController < ApplicationController
  before_action :authenticate_owner!
  before_action do
    set_room
    check_owner(@room.inn.id)
  end

  def new
    @custom_price = CustomPrice.new
  end

  def create
    @custom_price = @room.custom_prices.build(custom_price_params)
    if @custom_price.save
      return redirect_to inn_room_path(@room.inn, @room), notice: "Preço personalizado cadastrado com sucesso!"
    end
    flash[:alert] = "Não foi possível cadastrar o preço personalizado"
    render :new
  end

  def destroy
    @custom_price = @room.custom_prices.find(params[:id])
    if @custom_price.destroy
      return redirect_to inn_path(@room.inn), notice: "Preço personalizado apagado com sucesso!"
    else
      flash[:alert] = "Não foi possível apagar o preço personalizado"
      return redirect_to inn_path(@room.inn)
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def custom_price_params
    params.require(:custom_price).permit(:start_date, :end_date, :price)
  end
end