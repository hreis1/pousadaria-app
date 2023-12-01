class Api::V1::InnsController < Api::V1::ApiController
  def index
    inns = Inn.where(active: true)
    if params[:trade_name]
      inns = inns.where("trade_name LIKE ?", "%#{params[:trade_name]}%")
    end
    render json: inns.as_json(only: [:id, :trade_name])
  end

  def show
    inn = Inn.where(active: true).find(params[:id])
    inn_json = inn.as_json(except: [:cnpj, :corporate_name, :created_at, :updated_at])
    inn_json["average_score"] = inn.calculate_average_rating ? inn.calculate_average_rating : ''
    p inn_json["average_score"]
    inn_json["checkin_time"] = inn.checkin_time.strftime("%H:%M")
    inn_json["checkout_time"] = inn.checkout_time.strftime("%H:%M")
    render status: 200, json: inn_json
  end
end