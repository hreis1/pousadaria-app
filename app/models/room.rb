class Room < ApplicationRecord
  validates :name, :description, :dimension, :max_occupancy, :daily_rate, presence: true
  validates :max_occupancy, :daily_rate, numericality: { greater_than: 0 }

  belongs_to :inn
end
