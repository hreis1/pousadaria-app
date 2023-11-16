require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid?' do
    it "atributos não podem ser vazios" do
      reservation = Reservation.new

      reservation.valid?

      expect(reservation.errors[:checkin]).to include('não pode ficar em branco')
      expect(reservation.errors[:checkout]).to include('não pode ficar em branco')
      expect(reservation.errors[:number_of_guests]).to include('não pode ficar em branco')
    end

    it "data de entrada deve ser menor que data de saída" do
      reservation = Reservation.new(checkin: 1.day.from_now, checkout: 1.day.ago, number_of_guests: 2)

      reservation.valid?

      expect(reservation.errors[:checkin]).to include('deve ser menor que a data de saída')
    end

    it "data de entrada deve ser maior que data atual" do
      reservation = Reservation.new(checkin: 2.day.ago, checkout: 1.day.from_now, number_of_guests: 2)

      reservation.valid?

      expect(reservation.errors[:checkin]).to include('deve ser maior que a data atual')
    end

    it "número de hóspedes deve ser maior que zero" do
      reservation = Reservation.new(checkin: 1.day.from_now, checkout: 1.day.from_now, number_of_guests: 0)

      reservation.valid?

      expect(reservation.errors[:number_of_guests]).to include('deve ser maior que 0')
    end

    it "número de hóspedes deve ser menor que a capacidade máxima do quarto" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100.00, has_bathroom: true, has_balcony: false, has_air_conditioning: true, has_tv: true, has_closet: false, has_safe: false, is_accessible: false, is_available: true)
      reservation = Reservation.new(checkin: 1.day.from_now, checkout: 1.day.from_now, number_of_guests: 3, room: quarto)
      
      reservation.valid?

      expect(reservation.errors[:number_of_guests]).to include('deve ser menor ou igual a capacidade máxima do quarto')
    end
  end
end
