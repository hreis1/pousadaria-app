class Api::V1::InnsController < Api::V1::ApiController
  def index
    inns = Inn.where(active: true)
    if params[:trade_name]
      inns = inns.where("trade_name LIKE ?", "%#{params[:trade_name]}%")
    end
    render json: inns.as_json(only: [:id, :trade_name])
  end
end