class Reservation < ApplicationRecord
  validates :checkin, :checkout, :number_of_guests, presence: true
  validates :number_of_guests, numericality: { greater_than: 0 }

  validate :checkin_cannot_be_less_than_today
  validate :number_of_guests_cannot_be_greater_than_room_max_occupancy
  validate :checkin_cannot_be_greater_than_checkout
  validate :range_cannot_be_booked

  before_save :calculate_total_price

  belongs_to :room


  def total_value
    total_value = 0
    (checkin..checkout).each do |date|
      if room.custom_prices && room.custom_prices.find_by("? between start_date and end_date", date)
        total_value += self.room.custom_prices.find_by("? between start_date and end_date", date).price
      else
        total_value += self.room.daily_rate
      end
    end
    total_value
  end


  private


  def calculate_total_price
    if checkin && checkout && room
      total_price = (checkout - checkin).to_i * room.current_daily_rate
    end
  end
  
  def range_cannot_be_booked
    if checkin && checkout && room
      room.reservations.each do |reservation|
        if checkin.between?(reservation.checkin, reservation.checkout) ||
          checkout.between?(reservation.checkin, reservation.checkout)
          errors.add(:checkin, 'já está reservado')
          errors.add(:checkout, 'já está reservado')
        end
      end
    end
  end


  def checkin_cannot_be_greater_than_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, 'deve ser menor que a data de saída')
    end
  end

  def number_of_guests_cannot_be_greater_than_room_max_occupancy
    if number_of_guests && room && number_of_guests > room.max_occupancy
      errors.add(:number_of_guests, 'deve ser menor ou igual a capacidade máxima do quarto')
    end
  end

  def checkin_cannot_be_less_than_today
    if checkin && checkin < Date.today
      errors.add(:checkin, 'deve ser maior que a data atual')
    end
  end
end
