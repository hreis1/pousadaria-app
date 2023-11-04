class InnsController < ApplicationController
  before_action :authenticate_owner! , only: [:new, :create, :edit, :update]
  before_action :set_inn, only: [:show, :edit, :update]
  before_action :owner_has_inn, only: [:new, :create]
  before_action :check_owner, only: [:edit, :update]

  def show
    if current_owner.present? && current_owner == @inn.owner
      @rooms = @inn.rooms
    else
      @rooms = @inn.rooms.where(is_available: true)
    end
  end

  def new
    @inn = Inn.new
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.owner = current_owner
    if @inn.save
      return redirect_to @inn, notice: "Pousada cadastrada com sucesso"
    end
    render :new
  end

  def edit; end

  def update
    if @inn.update(inn_params)
      return redirect_to @inn, notice: "Pousada atualizada com sucesso"
    end
    flash.now[:alert] = "Não foi possível atualizar a pousada"
    render :edit
  end

  def search
    if params[:query].blank?
      return redirect_to root_path, alert: "Digite o Nome da Pousada"
    end
    @inns = Inn.where("trade_name LIKE ?", "%#{params[:query]}%").where(active: true)
    if @inns.empty?
      flash.now[:alert] = "Nenhuma pousada encontrada"
    end
  end


  private

  def set_inn
    @inn = Inn.find(params[:id])
    if !@inn.active && current_owner != @inn.owner
      return redirect_to root_path, alert: "Pousada inativa"
    end
  end

  def check_owner
    if @inn.owner != current_owner
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
  end

  def owner_has_inn
    if current_owner.inn.present?
      return redirect_to root_path, alert: "Você já possui uma pousada cadastrada"
    end
  end

  def inn_params
    inn_params = params.require(:inn).permit(:trade_name, :corporate_name, :cnpj, :phone, :email, :address, :address_number, :neighborhood, :state, :city, :cep, :description, :payment_methods, :pets_allowed, :polices, :checkin_time, :checkout_time, :active)
  end
end