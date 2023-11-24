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

  it "e retorna para a página de login se não estiver logado" do
    visit owner_reservations_path

    expect(current_path).to eq(new_owner_session_path)
  end
end

    
  
