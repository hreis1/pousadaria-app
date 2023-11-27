class Reservation < ApplicationRecord
  enum status: { pending: 0, canceled: 5, active: 10 , finished: 15 }

  validates :checkin, :checkout, :number_of_guests, :room, presence: true
  validates :number_of_guests, numericality: { greater_than: 0 }
  validates :code, uniqueness: true
  
  validate :checkin_cannot_be_less_than_today, on: :create
  validate :number_of_guests_cannot_be_greater_than_room_max_occupancy, on: :create
  validate :checkin_cannot_be_greater_than_checkout, on: :create
  validate :range_cannot_be_booked, on: :create
  validate :room_cannot_be_unavailable, on: :create

  before_validation :generate_code, on: :create

  belongs_to :room
  has_one :owner, through: :room
  belongs_to :user, optional: true


  def active!
    self.status = :active
    self.checkin_at = Time.zone.now
  end

  def finished!
    self.status = :finished
    self.checkout_at = Time.zone.now
  end

  def total_value
    total = 0
    (checkin...checkout).each do |date|
      total += calculate_price_for_date(date)
    end
    total
  end

  def current_total_value
    total = 0
    if checkout_at - checkin.to_datetime < 1.day
      return calculate_price_for_date(checkin)
    end
    (checkin...checkout_at.to_date).each do |date|
      total += calculate_price_for_date(date)
    end
    if checkout_at.time.hour >= room.inn.checkout_time.hour
      total += calculate_price_for_date(checkout_at.to_date)
    end
    total
  end

  def calculate_price_for_date(date)
    if room.custom_prices && room.custom_prices.find_by("? between start_date and end_date", date)
      room.custom_prices.find_by("? between start_date and end_date", date).price
    else
      room.daily_rate
    end
  end


  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
  
  def room_cannot_be_unavailable
    if room && !room.is_available
      errors.add(:room, 'não está disponível')
    end
  end
  
  def range_cannot_be_booked
    if checkin && checkout && room
      if room.reservations.where(status: [:pending, :active]).find_by("? between checkin and checkout OR ? between checkin and checkout", checkin, checkout)
        errors.add(:room_id, 'já está reservado')
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
    if checkin && checkin < Time.zone.today
      errors.add(:checkin, 'deve ser maior que a data atual')
    end
  end
end
