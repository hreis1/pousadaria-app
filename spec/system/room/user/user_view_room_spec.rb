require "rails_helper"

describe "Usuário vê quartos de uma pousada" do
  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    Room.create!(name: "Suíte Azul", description: "Suíte com cama de casal, TV e ar condicionado", dimension: "30m²", max_occupancy: 2, daily_rate: 150, has_bathroom: true, has_balcony: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)

    visit root_path
    click_on "Pousada Ribeiropolis"

    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Descrição: Quarto com cama de casal, TV e ar condicionado")
    expect(page).to have_content("Diária: R$ 100,00")
  end

  it "e não existem quartos cadastrados" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    visit root_path
    click_on "Pousada Ribeiropolis"

    expect(page).to have_content("Não há quartos cadastrados")
  end

  it "e não vê quartos inativos" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    Room.create!(name: "Suíte Azul", description: "Suíte com cama de casal, TV e ar condicionado", dimension: "30m²", max_occupancy: 2, daily_rate: 150, has_bathroom: true, has_balcony: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last, is_available: false)

    visit root_path
    click_on "Pousada Ribeiropolis"

    expect(page).to have_content("Quarto Rosa")
    expect(page).not_to have_content("Suíte Azul")
  end
end