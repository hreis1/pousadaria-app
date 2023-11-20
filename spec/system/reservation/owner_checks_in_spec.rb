require "rails_helper"

describe "Dono realiza check-in" do
  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id)
    
    login_as dono, scope: :owner

    visit root_path
    click_on "Reservas"
    click_on "#{reserva.code}"
    click_on "Check-in"

    within "nav" do
      expect(page).to have_content("Estadias Ativas")
    end
    expect(page).to have_content("Estadia iniciada: #{Time.now.strftime('%d/%m/%Y %H:%M')}")
    expect(page).to have_content("Quarto: Quarto Rosa")
    expect(page).to have_content("Data de entrada: #{reserva.checkin.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Data de saída: #{reserva.checkout.strftime('%d/%m/%Y')}")
    expect(page).to have_content("Quantidade de hóspedes: #{reserva.number_of_guests}")
    expect(page).to have_content("Código da reserva: #{reserva.code}")
    expect(page).to have_content("Situação: Ativa")
  end
end