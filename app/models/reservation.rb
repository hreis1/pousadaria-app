class Reservation < ApplicationRecord
  enum status: { pending: 0, canceled: 5, active: 10 }

  validates :checkin, :checkout, :number_of_guests, :room, presence: true
  validates :number_of_guests, numericality: { greater_than: 0 }
  validates :code, uniqueness: true

  validate :checkin_cannot_be_less_than_today, on: :create
  validate :number_of_guests_cannot_be_greater_than_room_max_occupancy, on: :create
  validate :checkin_cannot_be_greater_than_checkout, on: :create
  validate :range_cannot_be_booked, on: :create

  before_validation :generate_code, on: :create

  belongs_to :room
  belongs_to :user, optional: true


  def total_value
    total_value = 0
    (checkin...checkout).each do |date|
      if room.custom_prices && room.custom_prices.find_by("? between start_date and end_date", date)
        total_value += self.room.custom_prices.find_by("? between start_date and end_date", date).price
      else
        total_value += self.room.daily_rate
      end
    end
    total_value
  end


  private


  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
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
