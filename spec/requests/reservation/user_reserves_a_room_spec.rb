require "rails_helper"

describe "Usuário faz reserva de pousada" do
  it "e pousada está desativada" do
    dono = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA",
                cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com",
                address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada",
                state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos",
                payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true,
                polices: "Não aceitamos animais de grande porte", checkin_time: "12:00",
                checkout_time: "12:00", active: false)
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado",
                 dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true,
                 has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    login_as hospede, scope: :user

    post room_reservations_path(Inn.last), params: { reservation: { checkin: "2021-10-10", checkout: "2021-10-12", number_of_guests: 2 } }
    
    expect(flash[:alert]).to eq "Não foi possível efetuar a reserva"
    expect(Reservation.count).to eq 0
  end

  it "com sucesso" do
    dono = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA",
                cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com",
                address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada",
                state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos",
                payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true,
                polices: "Não aceitamos animais de grande porte", checkin_time: "12:00",
                checkout_time: "12:00", active: false)
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado",
                 dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true,
                 has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    login_as hospede, scope: :user

    post room_reservations_path(Inn.last), params: { reservation: { checkin: 2.days.from_now, checkout: 4.days.from_now, number_of_guests: 2 , room_id: Room.last.id} }

    expect(flash[:notice]).to eq "Reserva efetuada com sucesso"
    expect(Reservation.count).to eq 1
    expect(Reservation.last.status).to eq "pending"
    expect(response).to redirect_to my_reservations_path
  end

  it "e quartos está indisponível" do
    dono = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA",
                cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com",
                address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada",
                state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos",
                payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true,
                polices: "Não aceitamos animais de grande porte", checkin_time: "12:00",
                checkout_time: "12:00", active: false)
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado",
                 dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true,
                 has_tv: false, inn: Inn.last, is_available: false)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    login_as hospede, scope: :user

    post room_reservations_path(Inn.last), params: { reservation: { checkin: 2.days.from_now, checkout: 4.days.from_now, number_of_guests: 2 } }

    expect(flash[:alert]).to eq "Não foi possível efetuar a reserva"
    expect(Reservation.count).to eq 0
  end
end