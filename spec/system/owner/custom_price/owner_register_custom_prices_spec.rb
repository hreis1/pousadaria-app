require 'rails_helper'

describe "Dono cadastra preço personalizado" do
  it "com sucesso" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100,has_bathroom: true, has_air_conditioning: true, inn: Inn.last)
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    within("div#room-#{Room.last.id}") do
      click_on "Adicionar Preço Personalizado"
    end
    fill_in "Preço", with: "50"
    fill_in "Data de início", with: 1.day.ago.strftime("%d/%m/%Y")
    fill_in "Data de término", with: 1.day.from_now.strftime("%d/%m/%Y")
    click_on "Cadastrar Preço Personalizado"

    expect(page).to have_content("Preço personalizado cadastrado com sucesso!")
    expect(page).to have_content("Diária: R$ 50,00")
    expect(page).to have_content("Preços Personalizados:")
    expect(page).to have_content("R$ 50,00 de #{1.day.ago.strftime("%d/%m/%Y")} até #{1.day.from_now.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Quarto Rosa")
  end

  it "e apaga um preço promocional" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100,has_bathroom: true, has_air_conditioning: true, inn: Inn.last)
    CustomPrice.create!(room: Room.last, price: 50, start_date: 1.day.ago, end_date: 1.day.from_now)
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    within("div#room-#{Room.last.id}") do
      click_on "Apagar"
    end

    expect(page).to have_content("Preço personalizado apagado com sucesso!")
    expect(page).not_to have_content("R$ 50,00 de #{1.day.ago.strftime("%d/%m/%Y")} até #{1.day.from_now.strftime("%d/%m/%Y")}")
  end

  it "e deve preencher todos os campos" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100,has_bathroom: true, has_air_conditioning: true, inn: Inn.last)
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    within("div#room-#{Room.last.id}") do
      click_on "Adicionar Preço Personalizado"
    end
    fill_in "Data de início", with: ""
    fill_in "Data de término", with: ""
    click_on "Cadastrar Preço Personalizado"

    expect(page).to have_content("Não foi possível cadastrar o preço personalizado")
    expect(page).to have_content("Data de início não pode ficar em branco")
    expect(page).to have_content("Data de término não pode ficar em branco")
    expect(page).to have_content("Preço não pode ficar em branco")
  end

  it "e já existe um preço personalizado para o período" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100,has_bathroom: true, has_air_conditioning: true, inn: Inn.last)
    login_as dono
    CustomPrice.create!(room: Room.last, price: 50, start_date: 1.day.ago, end_date: 1.day.from_now)

    visit root_path
    click_on "Minha Pousada"
    within("div#room-#{Room.last.id}") do
      click_on "Adicionar Preço Personalizado"
    end
    fill_in "Preço", with: "50"
    fill_in "Data de início", with: 1.day.ago.strftime("%d/%m/%Y")
    fill_in "Data de término", with: 1.day.from_now.strftime("%d/%m/%Y")
    click_on "Cadastrar Preço Personalizado"

    expect(page).to have_content("Não foi possível cadastrar o preço personalizado")
    expect(page).to have_content("Já existe um preço personalizado para o quarto na mesma data")
  end
end
