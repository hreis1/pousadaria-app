class InnsController < ApplicationController
  before_action :authenticate_owner!

  def show
    @inn = Inn.find(params[:id])
  end

  def new
    if current_owner.inn.present?
      return redirect_to root_path, alert: "Você já possui uma pousada cadastrada"
    end
    @inn = Inn.new
  end

  def create
    if current_owner.inn.present?
      return redirect_to root_path, alert: "Você já possui uma pousada cadastrada"
    end
    @inn = Inn.new(inn_params)
    @inn.owner = current_owner
    if @inn.save
      return redirect_to @inn, notice: "Pousada cadastrada com sucesso"
    end
    render :new
  end

  def edit
    @inn = Inn.find(params[:id])
    if @inn.owner != current_owner
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
  end

  def update
    @inn = Inn.find(params[:id])
    if @inn.owner != current_owner
      return redirect_to root_path, alert: "Você não tem permissão para acessar essa página"
    end
    if @inn.update(inn_params)
      return redirect_to @inn, notice: "Pousada atualizada com sucesso"
    end
    flash.now[:alert] = "Não foi possível atualizar a pousada"
    render :edit
  end

  def my_inn
    @inn = current_owner.inn
    if @inn.nil?
      return redirect_to root_path, alert: "Você não possui uma pousada cadastrada"
    end
  end


  private

  def inn_params
    inn_params = params.require(:inn).permit(:trade_name, :corporate_name, :cnpj, :phone, :email, :address, :address_number, :neighborhood, :state, :city, :cep, :description, :payment_methods, :pets_allowed, :polices, :checkin_time, :checkout_time, :active)
  end
end