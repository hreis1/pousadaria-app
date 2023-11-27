require "rails_helper"

describe "Dono cancela reserva" do
  it "e não está logado" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)

    post cancel_reservation_path(reserva)

    expect(response).to redirect_to new_owner_session_path
    expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    expect(reserva.reload.status).to eq("pending")
  end

  it "e ainda não se passaram 2 dias da data de checkin" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
    login_as dono, scope: :owner

    post cancel_reservation_path(reserva)

    expect(response).to redirect_to reservations_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("pending")
  end

  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 5.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
    login_as dono, scope: :owner

    travel_to 7.days.from_now do
      post cancel_reservation_path(reserva)
    end

    expect(response).to redirect_to reservations_path
    expect(flash[:notice]).to eq("Reserva cancelada com sucesso")
    expect(reserva.reload.status).to eq("canceled")
  end

  it "e não consegue cancelar reserva ativa" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 1.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :active, checkin_at: 1.day.from_now)
    login_as dono, scope: :owner

    post cancel_reservation_path(reserva)

    expect(response).to redirect_to reservations_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("active")
  end

  it "e não consegue cancelar reserva finalizada" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.new(user: hospede, room: Room.last, code: "ABC12345", checkin: 5.days.ago , checkout: 1.days.ago, number_of_guests: 2, status: :finished, checkin_at: 5.days.ago, checkout_at: 1.days.ago)
    reserva.save(validate: false)
    login_as dono, scope: :owner

    post cancel_reservation_path(reserva)

    expect(response).to redirect_to reservations_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("finished")
  end

  it "e não consegue cancelar reserva cancelada" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :canceled, checkin_at: 9.day.from_now, checkout_at: 11.days.from_now)
    login_as dono, scope: :owner

    post cancel_reservation_path(reserva)

    expect(response).to redirect_to reservations_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("canceled")
  end

  it "e não consegue cancelar reserva de outro dono" do
    dono = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    outro_dono = Owner.create!(email: "b@email.com", password: "senhadonob")
    Inn.create!(owner: outro_dono, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Família", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 4, daily_rate: 100, has_bathroom: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 2.day.from_now, checkout: 6.days.from_now, number_of_guests: 2, status: :pending)
    login_as dono, scope: :owner

    travel_to 3.days.from_now do
      post cancel_reservation_path(reserva)
    end

    expect(response).to redirect_to reservations_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("pending")
  end
end
