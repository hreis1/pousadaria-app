class Api::V1::RoomsController < Api::V1::ApiController
  def index
    inn = Inn.where(active: true).find(params[:inn_id])
    rooms = inn.rooms.where(is_available: true)
    render status: 200, json: rooms.as_json(except: [:is_available, :created_at, :updated_at])
  end
end