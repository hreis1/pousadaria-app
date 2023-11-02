class Inn < ApplicationRecord
  validates :trade_name, :corporate_name, :cnpj, :phone, :email, :address,
                         :address_number, :neighborhood, :state, :city, :cep, :description,
                         :payment_methods, :polices, :checkin_time, :checkout_time,presence: true

  validates :cnpj, uniqueness: true
  validates :cnpj, length: { is: 14 }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "formato inválido" }
  validates :email, uniqueness: true
  validates :cep, format: { with: /\A\d{5}-?\d{3}\z/, message: "formato inválido" }
  validates :phone, format: { with: /\A[0-9]{11}\z/, message: "formato inválido" }
  validates :phone, uniqueness: true
  
  validate :owner_has_inn, on: :create 

  
  belongs_to :owner


  private

  def owner_has_inn
    if Inn.where(owner: self.owner).any?
      errors.add(:owner, "já possui uma pousada cadastrada")
    end
  end
end
