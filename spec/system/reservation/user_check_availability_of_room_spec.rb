require "rails_helper"

describe "Usuário verifica disponibilidade de quarto" do
  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)

    visit root_path
    click_on "Pousada Ribeiropolis"
    within("div#room-#{Room.last.id}") do
      click_on "Reservar"
    end
    data_entrada = 0.day.from_now.strftime("%d/%m/%Y")
    data_saida = 3.days.from_now.strftime("%d/%m/%Y")
    fill_in "Data de entrada", with: data_entrada
    fill_in "Data de saída", with: data_saida
    fill_in "Quantidade de hóspedes", with: 2
    click_on "Verificar disponibilidade"

    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Valor total: R$ 400,00")
  end

  it "e não preenche todos os campos" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)

    visit root_path
    click_on "Pousada Ribeiropolis"
    within("div#room-#{Room.last.id}") do
      click_on "Reservar"
    end
    fill_in "Data de entrada", with: ""
    fill_in "Data de saída", with: ""
    fill_in "Quantidade de hóspedes", with: ""
    click_on "Verificar disponibilidade"
    
    expect(page).to have_content("Data de entrada não pode ficar em branco")
    expect(page).to have_content("Data de saída não pode ficar em branco")
    expect(page).to have_content("Quantidade de hóspedes não pode ficar em branco")
  end

  it "e já existe uma reserva para o mesmo quarto no mesmo período" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "721.393.310-23", password: "password")
    reserva = Reservation.create!(room: Room.last, checkin: 0.days.ago , checkout: 5.days.from_now, number_of_guests: 2, user_id: hospede.id)

    visit root_path
    click_on "Pousada Ribeiropolis"
    within("div#room-#{Room.last.id}") do
      click_on "Reservar"
    end
    data_entrada = 1.day.from_now.strftime("%d/%m/%Y")
    data_saida = 3.day.from_now.strftime("%d/%m/%Y")
    fill_in "Data de entrada", with: data_entrada
    fill_in "Data de saída", with: data_saida
    fill_in "Quantidade de hóspedes", with: 2
    click_on "Verificar disponibilidade"

    expect(page).to have_content("Verificar disponibilidade")
    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Data de entrada já está reservado")
    expect(page).to have_content("Data de saída já está reservado")
    expect(page).to have_content("Reserva não disponível")
    expect(Reservation.last).to eq(reserva)
  end
end
