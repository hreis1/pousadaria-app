class CustomPrice < ApplicationRecord
  validates :start_date, :end_date, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  validate :start_date_must_be_less_than_end_date
  validate :already_exists_custom_price_for_room_in_same_date

  belongs_to :room

  def start_date_must_be_less_than_end_date
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:start_date, "deve ser menor que a data final")
    end
  end

  def already_exists_custom_price_for_room_in_same_date
    if start_date.present? && end_date.present? && room.present? && room.custom_prices.where("? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date ", start_date, end_date).any?
      errors.add(:base, "Já existe um preço personalizado para o quarto na mesma data")
    end
  end
end
