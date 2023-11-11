class RoomsController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]
  before_action :set_inn, only: [:new, :create, :edit, :update]
  before_action :check_owner_and_set_room, only: [:edit, :update]
  before_action :set_room, only: [:show]
  
  def show
    @current_daily_rate = @room.custom_prices.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)
    if @current_daily_rate.nil?
      @current_daily_rate = @room.daily_rate
    else
      @current_daily_rate = @current_daily_rate.price
    end
    @custom_prices = @room.custom_prices
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.inn = @inn
    if @room.save
      return redirect_to inn_room_path(@inn, @room), notice: "Quarto cadastrado com sucesso!"
    end
    flash.now[:alert] = "Não foi possível cadastrar o quarto"
    render :new
  end

  def edit; end

  def update
    if @room.update(room_params)
      return redirect_to inn_room_path(@inn, @room), notice: "Quarto atualizado com sucesso!"
    end
    flash.now[:alert] = "Não foi possível atualizar o quarto"
    render :edit
  end
  
  
  private

  def room_params
    params.require(:room).permit(:name, :description, :dimension, :max_occupancy, :daily_rate, :has_bathroom, :has_balcony, :has_air_conditioning, :has_tv, :has_closet, :has_safe, :is_accessible, :is_available)
  end

  def set_inn
    @inn = current_owner.inn
    if @inn.nil?
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
  end

  def check_owner_and_set_room
    unless Room.find(params[:id]).inn.owner == @inn.owner
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
    @room = @inn.rooms.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:id])
    if !@room.inn.active && @room.inn.owner != current_owner
      return redirect_to root_path, alert: "Pousada inativa"
    end
    if !@room.is_available && @room.inn.owner != current_owner
      return redirect_to root_path, alert: "Quarto não disponível"
    end
  end
end