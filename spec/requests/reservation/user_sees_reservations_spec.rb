require "rails_helper"

describe "Usuário vê reservas" do
  context "e é hóspede" do
    it "e não está logado" do
      get user_reservations_path

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    end

    it "e não tem reservas" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      login_as hospede, scope: :user

      get user_reservations_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("Você ainda não possui reservas")
    end

    it "com sucesso" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
      login_as hospede, scope: :user

      get user_reservations_path

      expect(response).to have_http_status(200)
      expect(response.body).to include(reserva.code)
    end

    it "e não consegue ver reservas de outro usuário" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      outro_hospede = User.create!(name: "Beltrano de Tal", email: "bdt@email", cpf: "72139331024", password: "password")
      reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2, status: :pending)
      reserva_outro_hospede = Reservation.create!(user: outro_hospede, room: Room.last, code: "ABC12346", checkin: 13.day.from_now, checkout: 15.days.from_now, number_of_guests: 2, status: :pending)

      login_as hospede, scope: :user

      get user_reservations_path

      expect(response).to have_http_status(200)
      expect(response.body).to include(reserva.code)
      expect(response.body).not_to include(reserva_outro_hospede.code)
    end
  end

  context "e é dono" do
    it "e não está logado" do
      get reservations_path

      expect(response).to redirect_to new_owner_session_path 
      expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    end

    it "não está logado e tenta vê reservas ativas" do
      get active_reservations_path

      expect(response).to redirect_to new_owner_session_path
      expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    end

    it "com sucesso" do
      dono = Owner.create!(email: "d@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2)
      login_as dono, scope: :owner

      get reservations_path

      expect(response).to have_http_status(200)
      expect(response.body).to include(reserva.code)
    end

    it "e não consegue ver reserva de outro dono" do
      dono = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      outro_dono = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: outro_dono, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Família", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 4, daily_rate: 100, has_bathroom: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)
      hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
      reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 2.day.from_now, checkout: 6.days.from_now, number_of_guests: 2, status: :pending)
      login_as dono, scope: :owner
      
      get reservation_path(reserva)

      expect(response).to redirect_to reservations_path
      expect(flash[:alert]).to eq("Você não tem permissão para acessar essa página")
    end
  end
end