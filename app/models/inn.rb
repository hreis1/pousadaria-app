class Inn < ApplicationRecord
  validates :trade_name, :corporate_name, :cnpj, :phone, :email, :address,
                         :address_number, :neighborhood, :state, :city, :cep,
                         :description, :payment_methods, :polices, :checkin_time,
                         :checkout_time, presence: true

  validates :cnpj, :phone, :email, :phone, uniqueness: true
  validates :cnpj, length: { is: 14 }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "formato inválido" }
  validates :cep, format: { with: /\A\d{5}-?\d{3}\z/, message: "formato inválido" }
  validates :phone, format: { with: /\A[0-9]{11}\z/, message: "formato inválido" }
  
  validate :owner_has_inn, on: :create

  belongs_to :owner
  has_many :rooms
  has_many :reservations, through: :rooms
  has_many :rates, through: :reservations

  def full_address
    "#{address}, #{address_number}, #{neighborhood}, #{city} - #{state}"
  end

  def calculate_average_rating
    if rates.any?
      rates.average(:rating).to_f.round(1)
    else
      0
    end
  end
  
  private

  def owner_has_inn
    if Inn.where(owner: self.owner).any?
      errors.add(:owner, "já possui uma pousada cadastrada")
    end
  end
end
