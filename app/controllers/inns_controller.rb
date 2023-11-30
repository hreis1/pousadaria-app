class InnsController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]
  before_action :set_inn, only: [:show, :edit, :update]
  before_action :check_owner, only: [:edit, :update]

  def show
    @reviews = @inn.reservations.limit(3).map(&:rate)
    @average_rating = @inn.calculate_average_rating
    return @rooms = @inn.rooms if current_owner.present? && current_owner == @inn.owner
    return @rooms = @inn.rooms.where(is_available: true) if @inn.active?
    redirect_to root_path, alert: "Pousada inativa"
  end

  def new
    return redirect_to root_path, alert: "Você já possui uma pousada cadastrada" if current_owner.inn
    @inn = Inn.new
  end

  def create
    return redirect_to root_path, alert: "Você já possui uma pousada cadastrada" if current_owner.inn
    @inn = current_owner.build_inn(inn_params)
    return redirect_to @inn, notice: "Pousada cadastrada com sucesso" if @inn.save
    flash.now[:alert] = "Não foi possível cadastrar a pousada"
    render :new
  end

  def edit; end

  def update
    return redirect_to @inn, notice: "Pousada atualizada com sucesso" if @inn.update(inn_params)
    flash.now[:alert] = "Não foi possível atualizar a pousada"
    render :edit
  end

  def search
    @query = params[:query]
    return redirect_to root_path, alert: "Digite o Nome da Pousada" if @query.blank?
    @inns = Inn.where("trade_name LIKE :query OR neighborhood LIKE :query OR city LIKE :query", query: "%#{@query}%")
               .where(active: true)
               .order(:trade_name)
    flash.now[:alert] = "Nenhuma pousada encontrada" if @inns.empty?
  end


  private

  def set_inn
    begin
      @inn = Inn.find(params[:id])
    rescue
      return redirect_to root_path, alert: "Pousada não encontrada"
    end
  end

  def check_owner
    redirect_to root_path, alert: "Você não tem permissão para acessar essa página" unless current_owner == @inn.owner
  end

  def inn_params
    inn_params = params.require(:inn).permit(:trade_name, :corporate_name, :cnpj, :phone, :email, :address,
                                             :address_number, :neighborhood, :state, :city, :cep, :description,
                                             :payment_methods, :pets_allowed, :polices, :checkin_time, :checkout_time,
                                             :active)
  end
end