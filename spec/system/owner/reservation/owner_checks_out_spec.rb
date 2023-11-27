require "rails_helper"

describe "Dono realiza check-out" do
  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id, status: :active, checkin_at: Time.zone.now)
    login_as dono, scope: :owner

    travel_to 5.days.from_now do
      visit root_path
      click_on "Estadias Ativas"
      click_on reserva.code
      click_on "Check-out"
      select "Dinheiro", from: "Selecionar forma de pagamento"
      click_on "Finalizar"

      expect(page).to have_content("Reserva finalizada com sucesso")
      expect(page).to have_content("Situação: Finalizada")
      expect(page).to have_content("Forma de pagamento: Dinheiro")
      expect(page).to have_content("Valor pago: R$ 600,00")
    end
  end

  it "e vê o total da estadia" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id, status: :active, checkin_at: Time.zone.now)
    login_as dono, scope: :owner

    travel_to 5.days.from_now do
      visit root_path
      click_on "Estadias Ativas"
      click_on reserva.code
      click_on "Check-out"

      expect(page).to have_content("Total: R$ 600,00")
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
      visit root_path
      click_on "Estadias Ativas"
      click_on reserva.code
      click_on "Check-out"
      select "Cartão de crédito ou débito", from: "Selecionar forma de pagamento"
      click_on "Finalizar"

      expect(page).to have_content("Reserva finalizada com sucesso")
      expect(page).to have_content("Situação: Finalizada")
      expect(page).to have_content("Forma de pagamento: Cartão de crédito ou débito")
      expect(page).to have_content("Valor pago: R$ 600,00")
    end
  end

  it "e total é calculado com preço promocional" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    CustomPrice.create!(room: Room.last, start_date: 0.day.ago, end_date: 1.day.from_now, price: 50)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 2.days.from_now, number_of_guests: 2, user: hospede, status: :active, checkin_at: Time.zone.now)
    login_as dono

    travel_to 2.days.from_now do
      visit root_path
      click_on "Estadias Ativas"
      click_on reserva.code
      click_on "Check-out"

      expect(page).to have_content("Total: R$ 200,00")
      expect(page).to have_content("Selecionar forma de pagamento")
      expect(page).to have_content("Dinheiro")
      expect(page).to have_content("Cartão de crédito ou débito")
      expect(page).to have_button("Finalizar")
    end
  end

  it "e check-out é feito no dia do check-in" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede, status: :active, checkin_at: Time.zone.now)
    login_as dono

    travel_to 1.minute.from_now do
      visit root_path
      click_on "Estadias Ativas"
      click_on reserva.code
      click_on "Check-out"
      
      expect(page).to have_content("Total: R$ 100,00")
      expect(page).to have_content("Selecionar forma de pagamento")
    end
  end
end