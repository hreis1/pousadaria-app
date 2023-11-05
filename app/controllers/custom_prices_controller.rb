class CustomPricesController < ApplicationController
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

  
  private

  def custom_price_params
    params.require(:custom_price).permit(:start_date, :end_date, :price)
  end
end