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


  private

  def inn_params
    inn_params = params.require(:inn).permit(:trade_name, :corporate_name, :cnpj, :phone, :email, :address, :address_number, :neighborhood, :state, :city, :cep, :description, :payment_methods, :pets_allowed, :polices, :checkin_time, :checkout_time)
  end
end