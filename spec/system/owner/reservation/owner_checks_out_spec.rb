require "rails_helper"

describe "Dono realiza check-out" do
  it "e vê o total da estadia" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id, status: :active, checkin_at: Time.zone.now)
    login_as dono, scope: :owner

    travel_to 5.days.from_now do
      visit owner_reservation_path(reserva)
      click_on "Check-out"

      expect(page).to have_content("Total: R$ 500,00")
      expect(page).to have_content("Selecionar forma de pagamento")
      expect(page).to have_content("Dinheiro")
      expect(page).to have_content("Cartão de crédito ou débito")
      expect(page).to have_button("Finalizar")
    end
  end

  it "e escolhe a forma de pagamento" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id, status: :active, checkin_at: Time.zone.now)
    login_as dono, scope: :owner

    travel_to 5.days.from_now do
      visit owner_reservation_path(reserva)
      click_on "Check-out"
      select "Cartão de crédito ou débito", from: "Selecionar forma de pagamento"
      click_on "Finalizar"

      expect(page).to have_content("Check-out realizado com sucesso")
      expect(page).to have_content("Situação: Finalizada")
      expect(page).to have_content("Forma de pagamento: Cartão de crédito ou débito")
      expect(page).to have_content("Valor pago: R$ 500,00")
    end
  end
end