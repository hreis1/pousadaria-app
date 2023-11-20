require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid?' do
    it "atributos não podem ser vazios" do
      reservation = Reservation.new

      reservation.valid?

      expect(reservation.errors[:checkin]).to include('não pode ficar em branco')
      expect(reservation.errors[:checkout]).to include('não pode ficar em branco')
      expect(reservation.errors[:number_of_guests]).to include('não pode ficar em branco')
      expect(reservation.errors[:room]).to include('é obrigatório(a)')
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

  it "deve ter um usuário" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)
    reservation = Reservation.new(checkin: 1.day.from_now, checkout: 2.day.from_now, number_of_guests: 2, room: quarto)
    result = reservation.save

    expect(result).to eq(false)
  end

  it "e verificia se o quarto está disponível mesmo sem usuário" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)
    reservation = Reservation.new(checkin: 1.day.from_now, checkout: 1.day.from_now, number_of_guests: 2, room: quarto)
    
    reservation.valid?

    expect(reservation.errors[:user_id]).to eq([])
  end
  
  describe '#total_value' do
    it 'deve ser igual ao valor da diária multiplicado pelo número de dias' do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      reserva = Reservation.new(checkin: 0.day.from_now, checkout: 1.days.from_now, number_of_guests: 2, room: quarto, user_id: hospede)

      expect(reserva.total_value).to eq(100)
    end

    it 'deve ser igual ao valor da diária multiplicado pelo número de dias com preço personalizado' do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)

      preco_personalizado = CustomPrice.create!(room: quarto, start_date: 1.day.from_now, end_date: 3.days.from_now, price: 150)
      reserva = Reservation.new(checkin: 1.day.from_now, checkout: 3.days.from_now, number_of_guests: 2, room: quarto)
      
      expect(reserva.total_value).to eq(300)
    end
  end

  describe '#generate_code' do
    it 'Código deve ser gerado automaticamente' do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      reservation = Reservation.create!(checkin: 1.day.from_now, checkout: 2.day.from_now, number_of_guests: 2, room: quarto, user_id: hospede.id)

      expect(reservation.code).not_to be_empty
      expect(reservation.code.size).to eq(8)
    end

    it "Código não deve ser alterado após a criação" do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      reservation = Reservation.create!(checkin: 1.day.from_now, checkout: 2.day.from_now, number_of_guests: 2, room: quarto, user_id: hospede.id)
      original_code = reservation.code

      reservation.update!(number_of_guests: 1)

      expect(reservation.code).to eq(original_code)
    end

    it "Código deve ser único" do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
      Reservation.create!(checkin: 1.day.from_now, checkout: 2.day.from_now, number_of_guests: 2, room: quarto, user_id: hospede.id)
      reservation = Reservation.new(checkin: 1.day.from_now, checkout: 2.day.from_now, number_of_guests: 2, room: quarto, user_id: hospede.id)

      reservation.valid?

      expect(reservation.errors[:code]).to include('já está em uso')
    end
  end
end