class Api::V1::RoomsController < Api::V1::ApiController
  def index
    inn = Inn.where(active: true).find(params[:inn_id])
    rooms = inn.rooms.where(is_available: true)
    render status: 200, json: rooms.as_json(except: [:is_available, :created_at, :updated_at])
  end

  def check
    room = Room.where(is_available: true).find(params[:id])
    checkin = params[:checkin]
    checkout = params[:checkout]
    number_of_guests = params[:number_of_guests]
    return render status: 400, json: { mensagem: "Parâmetros inválidos" } if checkin.blank? || checkout.blank? || number_of_guests.blank?
    return not_found_error unless room.inn.active
    reservation = room.reservations.build(checkin: checkin.to_date, checkout: checkout.to_date, number_of_guests: number_of_guests.to_i)
    if reservation.valid?
      price = reservation.total_value
      return render status: 200, json: { price: price }
    end
    return render status: 200, json: { mensagem: "Quarto indisponível" }
  end
end