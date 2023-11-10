require "rails_helper"

describe "Dono vê sua pousada" do
  it "e não está logado" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    visit root_path
    click_on "Pousada Ribeiropolis"

    expect(current_path).to eq(inn_path(dono.inn))
    expect(page).to have_content("Pousada Ribeiropolis")
    expect(page).to have_content("Endereço: Rua dos Bobos, 0, Liberdade, São Paulo - São Paulo")
    expect(page).to have_content("Telefone de contato: 11999999999")
    expect(page).to have_content("E-mail de contato: pr@email")
    expect(page).to have_content("Descrição: Pousada para todos os gostos")
    expect(page).to have_content("Formas de pagamento: Dinheiro, cartão de crédito ou débito")
    expect(page).to have_content("Aceita pets: Sim")
    expect(page).to have_content("Políticas: Não aceitamos animais de grande porte")
    expect(page).to have_content("Horário de checkin: 12:00")
    expect(page).to have_content("Horário de checkout: 12:00")
    expect(page).to have_content("Ativa: Sim")
    expect(page).not_to have_link("Editar")
    expect(page).not_to have_content "Pousada Ribeiropolis LTDA"
    expect(page).not_to have_content "12345678910111"
  end
  
  it "com sucesso" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    login_as dono

    visit root_path
    click_on "Minha Pousada"

    expect(current_path).to eq(inn_path(dono.inn))
    expect(page).to have_content("Pousada Ribeiropolis")
    expect(page).to have_content("Endereço: Rua dos Bobos, 0, Liberdade, São Paulo - São Paulo")
    expect(page).to have_content("Telefone de contato: 11999999999")
    expect(page).to have_content("E-mail de contato: pr@email")
    expect(page).to have_content("Descrição: Pousada para todos os gostos")
    expect(page).to have_content("Formas de pagamento: Dinheiro, cartão de crédito ou débito")
    expect(page).to have_content("Aceita pets: Sim")
    expect(page).to have_content("Políticas: Não aceitamos animais de grande porte")
    expect(page).to have_content("Horário de checkin: 12:00")
    expect(page).to have_content("Horário de checkout: 12:00")
    expect(page).to have_content("Ativa: Sim")
    expect(page).to have_content("CNPJ: 12345678910111")
    expect(page).to have_content("Razão Social: Pousada Ribeiropolis LTDA")
    expect(page).to have_link("Editar")
  end
end