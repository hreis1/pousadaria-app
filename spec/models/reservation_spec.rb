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

    it "não deve ser possível reservar um quarto que não está disponível" do
      dono = Owner.create!(email: "d@email.com", password: "password")
      Inn.create!(owner: dono, trade_name: "Pousada Diamante", corporate_name: "Pousada Diamante LTDA", cnpj: "12345678910115", phone: "11999999995", email: "pd@email.com", address: "Avenida das Araras", address_number: "10", neighborhood:"Araras", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro", polices: "Não aceitamos som automotivo", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create(name: "Suíte Master", description: "Suíte completa", dimension: "40m²", max_occupancy: 2, daily_rate: 200, has_bathroom: true, has_balcony: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)
      hospede = User.create!(name: "hospede", email: "h@email.com", cpf: "12345678910", password: "password")
      primeira_reserva = Reservation.create!(checkin: 1.day.from_now, checkout: 4.day.from_now, number_of_guests: 2, room: quarto, user: hospede)
      segunda_reserva = Reservation.new(checkin: 1.day.from_now, checkout: 4.day.from_now, number_of_guests: 2, room: quarto, user: hospede)

      segunda_reserva.valid?

      expect(segunda_reserva.errors[:room_id]).to include('já está reservado')
    end
  end

  it "e verificia se o quarto está disponível mesmo sem estar logado" do
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

  describe '#status' do
    it "deve ser 'pending' por padrão" do
      reservation = Reservation.new

      expect(reservation.status).to eq('pending')
    end
  end

  describe  "#current_total_value" do
    it "deve ser igual ao valor da diária se for feito o checkin e checkout no mesmo dia" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      hoje_ao_meio_dia_e_um_minuto = Time.zone.now.beginning_of_day + 12.hours + 1.minute
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: 1.day.from_now, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: hoje_ao_meio_dia_e_um_minuto)

      expect(reserva.current_total_value).to eq(100)
    end

    it "deve ser igual ao valor da diária se for somente um dia de hospedagem" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      amanha_ao_meio_dia = 1.day.from_now.beginning_of_day + 11.hours + 59.minutes
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: amanha_ao_meio_dia, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: amanha_ao_meio_dia)

      expect(reserva.current_total_value).to eq(100)
    end

    it "deve ser duas vezes o valor da diária se for dois dias de hospedagem" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      depois_de_amanha_ao_meio_dia = 2.days.from_now.beginning_of_day + 11.hours + 59.minutes
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: depois_de_amanha_ao_meio_dia, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: depois_de_amanha_ao_meio_dia)

      expect(reserva.current_total_value).to eq(200)
    end

    it "deve ser duas vezes o valor da diária se passar um minuto do checkout" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      amanha_ao_meio_dia = 1.day.from_now.beginning_of_day + 11.hours + 59.minutes
      amanha_ao_meio_dia_e_um_minuto = 1.day.from_now.beginning_of_day + 12.hours + 1.minute
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia.to_date , checkout: amanha_ao_meio_dia.to_date, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: amanha_ao_meio_dia_e_um_minuto)

      expect(reserva.current_total_value).to eq(200)
    end

    it "deve ser igual ao valor da diária se for somente um dia de hospedagem com preço personalizado" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      CustomPrice.create!(room: Room.last, start_date: 1.day.ago, end_date: 3.days.from_now, price: 150)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      amanha_ao_meio_dia = 1.day.from_now.beginning_of_day + 11.hours + 59.minutes
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: amanha_ao_meio_dia, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: amanha_ao_meio_dia)

      expect(reserva.current_total_value).to eq(150)
    end

    it "deve ser igual ao valor do preço personalizado se for somente um dia de hospedagem com preço personalizado e checkout no mesmo dia" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      CustomPrice.create!(room: Room.last, start_date: 1.day.ago, end_date: 3.days.from_now, price: 150)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      hoje_ao_meio_dia_e_um_minuto = Time.zone.now.beginning_of_day + 12.hours + 1.minute
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: 1.day.from_now, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: hoje_ao_meio_dia_e_um_minuto)

      expect(reserva.current_total_value).to eq(150)
    end

    it "deve ser igual ao valor da diária multiplicado pelo número de dias" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      daqui_a_cinco_dias = 5.days.from_now.beginning_of_day + 11.hours + 59.minutes
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: daqui_a_cinco_dias, number_of_guests: 2, user: hospede, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: daqui_a_cinco_dias)

      expect(reserva.current_total_value).to eq(500)
    end

    it "devem ser somados os valores das diárias com preço personalizado e das diárias com preço padrão" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      CustomPrice.create!(room: Room.last, start_date: 1.day.ago, end_date: 3.days.from_now, price: 10)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      hoje_ao_meio_dia = Time.zone.now.beginning_of_day + 12.hours
      daqui_a_cinco_dias = 5.days.from_now.beginning_of_day + 11.hours + 59.minutes
      reserva = Reservation.create!(room: Room.last, checkin: hoje_ao_meio_dia , checkout: daqui_a_cinco_dias, number_of_guests: 2, status: :finished, checkin_at: hoje_ao_meio_dia, checkout_at: daqui_a_cinco_dias, user: hospede)

      expect(reserva.current_total_value).to eq(140)
    end
  end
end