class RoomsController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]

  def show
    @inn = Inn.find(params[:inn_id])
    @room = Room.find(params[:id])
  end

  def new
    @inn = current_owner.inn
    @room = Room.new
  end

  def create
    @inn = current_owner.inn
    @room = Room.new(room_params)
    @room.inn = @inn
    if @room.save
      return redirect_to inn_room_path(@inn, @room), notice: "Quarto cadastrado com sucesso!"
    end
    flash.now[:alert] = "Não foi possível cadastrar o quarto"
    render :new
  end

  def edit
    @inn = current_owner.inn
    if @inn.nil? || @inn != Room.find(params[:id]).inn
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
    @room = @inn.rooms.find(params[:id])
  end

  def update
    @inn = current_owner.inn
    if @inn.nil? || @inn != Room.find(params[:id]).inn
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
    @room = @inn.rooms.find(params[:id])
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
end