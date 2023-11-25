class Room < ApplicationRecord
  validates :name, :description, :dimension, :max_occupancy, :daily_rate, presence: true
  validates :max_occupancy, :daily_rate, numericality: { greater_than: 0 }

  belongs_to :inn

  has_one :owner, through: :inn
  has_many :custom_prices
  has_many :reservations

  def current_daily_rate
    custom_price = custom_prices.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)
    custom_price.present? ? custom_price.price : daily_rate
  end
end
