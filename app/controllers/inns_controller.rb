class InnsController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]
  before_action only: [:edit, :update] do
    check_owner(params[:id])
  end

  def show
    begin
      @inn = Inn.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return redirect_to root_path, alert: "Pousada não encontrada"
    end

    if current_owner.present? && current_owner == @inn.owner
      @rooms = @inn.rooms
    elsif @inn.active?
      @rooms = @inn.rooms.where(is_available: true)
    else
      return redirect_to root_path, alert: "Pousada inativa"
    end
  end

  def new
    return redirect_to root_path, alert: "Você já possui uma pousada cadastrada" if current_owner.inn
    @inn = Inn.new
  end

  def create
    return redirect_to root_path, alert: "Você já possui uma pousada cadastrada" if current_owner.inn
    @inn = current_owner.build_inn(inn_params)
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
    @query = params[:query]
    if @query.blank?
      return redirect_to root_path, alert: "Digite o Nome da Pousada"
    end
    @inns = Inn.where("trade_name LIKE :query OR neighborhood LIKE :query OR city LIKE :query", query: "%#{@query}%")
               .where(active: true)
               .order(:trade_name)
    flash.now[:alert] = "Nenhuma pousada encontrada" if @inns.empty?
  end


  private

  def inn_params
    inn_params = params.require(:inn).permit(:trade_name, :corporate_name, :cnpj, :phone, :email, :address,
                                             :address_number, :neighborhood, :state, :city, :cep, :description,
                                             :payment_methods, :pets_allowed, :polices, :checkin_time, :checkout_time,
                                             :active)
  end
end