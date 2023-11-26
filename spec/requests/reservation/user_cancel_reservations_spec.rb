require "rails_helper"

describe "Usuário cancela reserva" do
  it "e não está logado" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
    
    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    expect(reserva.reload.status).to eq("pending")
  end

  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
    login_as hospede, scope: :user

    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to user_reservations_path
    expect(flash[:notice]).to eq("Reserva cancelada com sucesso")
    expect(reserva.reload.status).to eq("canceled")
  end

  it "e não consegue cancelar reserva ativa" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :active)
    login_as hospede, scope: :user
    
    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("active")
  end

  it "e não consegue cancelar reserva finalizada" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :finished)
    
    login_as hospede, scope: :user
    
    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("finished")
  end

  it "e não consegue cancelar reserva cancelada" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :canceled)
    login_as hospede, scope: :user
    
    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("canceled")
  end

  it "e já está com menos de 7 dias para o checkin" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 2.day.from_now, checkout: 5.days.from_now, number_of_guests: 2, status: :pending)
    login_as hospede, scope: :user

    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("pending")
  end

  it "e não consegue cancelar reserva de outro usuário" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    outro_hospede = User.create!(name: "Beltrano de Tal", email: "bdt@email", cpf: "72139331024", password: "password")
    reserva = Reservation.create!(user: outro_hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
    login_as hospede, scope: :user

    post cancel_user_reservation_path(reserva)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq("Não foi possível cancelar a reserva")
    expect(reserva.reload.status).to eq("pending")
  end
end
