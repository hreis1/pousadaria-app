require "rails_helper"

describe "Dono visualiza reservas" do
  it "a partir da homepage" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva1 = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id)
    reserva2 = Reservation.create!(room: Room.last, checkin: 6.days.from_now , checkout: 11.days.from_now, number_of_guests: 2, user_id: hospede.id)
    
    login_as dono, scope: :owner

    visit root_path
    click_on "Reservas"

    expect(page).to have_content("Reservas")
    expect(page).to have_content("Quarto: Quarto Rosa")
    expect(page).to have_content("Data de entrada: #{reserva1.checkin.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Data de saída: #{reserva1.checkout.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Quantidade de hóspedes: #{reserva1.number_of_guests}")
    expect(page).to have_content("Código da reserva: #{reserva1.code}")
    expect(page).to have_content("Quarto: Quarto Rosa")
    expect(page).to have_content("Data de entrada: #{reserva2.checkin.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Data de saída: #{reserva2.checkout.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Quantidade de hóspedes: #{reserva2.number_of_guests}")
    expect(page).to have_content("Código da reserva: #{reserva2.code}")
  end

  it "e não há reservas cadastradas" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    login_as dono, scope: :owner

    visit root_path
    click_on "Reservas"

    expect(page).to have_content("Reservas")
    expect(page).to have_content("Você ainda não possui reservas")
  end

  it "deve estar logado" do
    visit reservations_path

    expect(current_path).to eq(new_owner_session_path)
  end

  it "e não pode acessar reservas de outro dono" do
    dono = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    outro_dono = Owner.create!(email: "b@email.com", password: "senhadonob")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 200, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    Inn.create!(owner: outro_dono, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Família", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 4, daily_rate: 100, has_bathroom: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva_dono = Reservation.create!(room: Room.first, checkin: 1.days.from_now , checkout: 4.days.from_now, number_of_guests: 1, user: hospede)
    reserva_outro_dono = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede)

    login_as dono, scope: :owner

    visit root_path
    click_on "Reservas"
    
    expect(page).to have_content("Reservas")
    expect(page).to have_content("Quarto: Quarto Rosa")
    expect(page).to have_content("Data de entrada: #{reserva_dono.checkin.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Data de saída: #{reserva_dono.checkout.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Quantidade de hóspedes: #{reserva_dono.number_of_guests}")
    expect(page).to have_content("Código da reserva: #{reserva_dono.code}")
    expect(page).not_to have_content("Quarto: Quarto Família")
    expect(page).not_to have_content("Data de entrada: #{reserva_outro_dono.checkin.strftime('%d/%m/%Y')}")
    expect(page).not_to have_content("Data de saída: #{reserva_outro_dono.checkout.strftime('%d/%m/%Y')}")
    expect(page).not_to have_content("Quantidade de hóspedes: #{reserva_outro_dono.number_of_guests}")
    expect(page).not_to have_content("Código da reserva: #{reserva_outro_dono.code}")
  end

  it "e vê avaliação de hóspede" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede, status: :finished, checkin_at: Time.zone.now, checkout_at: 5.days.from_now, amount_paid: 500)
    avaliacao = Rate.create!(reservation: reserva, rating: 5, review: "Ótima pousada!")
    login_as dono, scope: :owner

    visit root_path
    click_on "Avaliações"

    expect(page).to have_content("Avaliação de #{hospede.name}")
    expect(page).to have_content("Nota: #{reserva.rate.rating}")
    expect(page).to have_content("Comentário: #{reserva.rate.review}")
  end
  
  it "e resposta de avaliação de hóspede" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede, status: :finished, checkin_at: Time.zone.now, checkout_at: 5.days.from_now, amount_paid: 500)
    avaliacao = Rate.create!(reservation: reserva, rating: 5, review: "Ótima pousada!")
    login_as dono, scope: :owner

    visit root_path
    click_on "Avaliações"
    fill_in "Resposta", with: "Obrigado pela avaliação!"
    click_on "Responder"

    expect(page).to have_content("Resposta: Obrigado pela avaliação!")
  end
end

    
  
