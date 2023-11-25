require "rails_helper"

describe "Usuário vê reservas" do
  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "hospede", email: "h@email.com", password: "password", cpf: "12345678910")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede)

    login_as hospede, scope: :user
    visit root_path
    click_on "Minhas Reservas"

    expect(page).to have_content("Minhas Reservas")
    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Data de entrada: #{reserva.checkin.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Horário de check-in: #{Inn.last.checkin_time.strftime("%H:%M")}")
    expect(page).to have_content("Data de saída: #{reserva.checkout.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Horário de check-out: #{Inn.last.checkout_time.strftime("%H:%M")}")
    expect(page).to have_content("Quantidade de hóspedes: 2")
    expect(page).to have_content("Total: R$ 500,00")
    expect(page).to have_content("Situação: Pendente")
  end

  it "e não vê reservas de outros usuários" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    outro_hospede = User.create!(name: "outro_hospede", email: "oh@email.com", password: "password", cpf: "12345678911")
    Reservation.create!(room: Room.last, checkin: 6.days.from_now, checkout: 7.days.from_now, number_of_guests: 1, user: outro_hospede)
    hospede = User.create!(name: "hospede", email: "h@email.com", password: "password", cpf: "12345678910")
    reserva_hospede1 = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede)
    reserva_hospede2 = Reservation.create!(room: Room.last, checkin: 9.days.from_now, checkout: 11.days.from_now, number_of_guests: 2, user: hospede)

    login_as hospede, scope: :user
    visit root_path
    click_on "Minhas Reservas"

    expect(page).to have_content("Minhas Reservas")
    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Data de entrada: #{reserva_hospede1.checkin.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Data de saída: #{reserva_hospede1.checkout.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Quantidade de hóspedes: 2")
    expect(page).to have_content("Total: R$ 500,00")
    expect(page).to have_content("Data de entrada: #{reserva_hospede2.checkin.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Data de saída: #{reserva_hospede2.checkout.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Quantidade de hóspedes: 2")
    expect(page).to have_content("Total: R$ 200,00")

    expect(page).not_to have_content("Data de entrada: #{Reservation.first.checkin.strftime("%d/%m/%Y")}")
    expect(page).not_to have_content("Data de saída: #{Reservation.first.checkout.strftime("%d/%m/%Y")}")
    expect(page).not_to have_content("Quantidade de hóspedes: 1")
    expect(page).not_to have_content("Total: R$ 100,00")
  end
end