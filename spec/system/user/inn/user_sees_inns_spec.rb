require "rails_helper"

describe "Usuário vê pousadas" do
  it "não está logado" do
    dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
    Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Itanhaem", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    visit root_path

    expect(page).not_to have_link("Minha Pousada")
    expect(page).not_to have_link("Sair")
    expect(page).to have_content("Pousadas")
    expect(page).to have_content("Pousada Enseada")
    expect(page).to have_content("São Paulo")
    expect(page).to have_content("Pousada Itanhaem")
    expect(page).to have_content("São Paulo")
  end

  it "e não há pousadas cadastradas" do
    visit root_path

    expect(page).to have_content("Pousadas")
    expect(page).to have_content("Nenhuma pousada cadastrada")
  end

  it "e vê apenas pousadas com a cidade selecionada" do
    dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
    Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    dono_c = Owner.create!(email: "c@email.com", password: "senhadonoc")
    Inn.create!(owner: dono_c, trade_name: "Pousada Pão de Queijo", corporate_name: "Pousada Pão de Queijo LTDA", cnpj: "12345678910114", phone: "11999999996", email: "ppdq@email.com", address: "Rua das Rosas", address_number: "7", neighborhood:"Santa Mônica", state: "Minas Gerais", city: "Belo Horizonte", cep: "31525-420", description: "Pousada para quem gosta de pão de queijo", payment_methods: "Dinheiro", polices: "Não aceitamos som automotivo", checkin_time: "12:00", checkout_time: "12:00")
  
    visit root_path
    within "aside#inns-cities" do
      click_on "Belo Horizonte"
    end

    expect(page).to have_content("Pousadas")
    expect(page).to have_content("Pousada Pão de Queijo")
    expect(page).not_to have_content("Pousada Enseada")
    expect(page).not_to have_content("Pousada Itanhaem")
  end

  it "e vê nota média da pousada" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, Cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva1 = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user: hospede, status: :finished, checkin_at: Time.zone.now, checkout_at: 5.days.from_now, amount_paid: 500)
    avaliacao1 = Rate.create!(reservation: reserva1, rating: 5, review: "Ótima pousada!", response: "Obrigado pela avaliação, volte sempre!")
    reserva2 = Reservation.create!(room: Room.last, checkin: 6.days.from_now, checkout: 7.days.from_now, number_of_guests: 1, user: hospede, status: :finished, checkin_at: 6.days.from_now, checkout_at: 7.days.from_now, amount_paid: 100)
    avaliacao2 = Rate.create!(reservation: reserva2, rating: 3, review: "Pousada boa, mas o café da manhã poderia ser melhor.", response: "Obrigado pela avaliação, volte sempre!")
    reserva3 = Reservation.create!(room: Room.last, checkin: 9.days.from_now, checkout: 11.days.from_now, number_of_guests: 2, user: hospede, status: :finished, checkin_at: 9.days.from_now, checkout_at: 11.days.from_now, amount_paid: 200)
    avaliacao3 = Rate.create!(reservation: reserva3, rating: 4, review: "Pousada ok, mas a limpeza poderia ser melhor.", response: "Obrigado pela avaliação, volte sempre!")

    visit root_path
    click_on "Pousada Ribeiropolis"

    expect(page).to have_content("Pousada Ribeiropolis")
    expect(page).to have_content("Nota média: 4")
    expect(page).to have_content("Avaliações")
    expect(page).to have_content("Nota: 5")
    expect(page).to have_content("Comentário: Ótima pousada!")
    expect(page).to have_content("Resposta: Obrigado pela avaliação, volte sempre!")
    expect(page).to have_content("Nota: 3")
    expect(page).to have_content("Comentário: Pousada boa, mas o café da manhã poderia ser melhor.")
    expect(page).to have_content("Resposta: Obrigado pela avaliação, volte sempre!")
    expect(page).to have_content("Nota: 4")
    expect(page).to have_content("Comentário: Pousada ok, mas a limpeza poderia ser melhor.")
    expect(page).to have_content("Resposta: Obrigado pela avaliação, volte sempre!")
  end
end
