require "rails_helper"

describe "Dono edita quarto" do
  it "sucesso" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100,has_bathroom: true, has_air_conditioning: true, inn: Inn.last)
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    click_on "Quarto Rosa"
    click_on "Editar"
    fill_in "Nome", with: "Quarto Master"
    fill_in "Descrição", with: "Quarto com vista para o mar"
    fill_in "Dimensão", with: "50"
    fill_in "Ocupação máxima", with: "4"
    fill_in "Diária", with: "100"
    check "Banheiro"
    check "Ar condicionado"
    check "TV"
    check "Armário"
    check "Cofre"
    check "Acessível"
    uncheck "Disponível"
    click_on "Atualizar Quarto"

    expect(page).to have_content("Quarto atualizado com sucesso!")
    expect(page).to have_content("Quarto Master")
    expect(page).to have_content("Descrição: Quarto com vista para o mar")
    expect(page).to have_content("Dimensão: 50 m²")
    expect(page).to have_content("Ocupação máxima: 4 pessoas")
    expect(page).to have_content("Diária: R$ 100,00")
    expect(page).to have_content("Banheiro: Sim")
    expect(page).to have_content("Ar condicionado: Sim")
    expect(page).to have_content("TV: Sim")
    expect(page).to have_content("Armário: Sim")
    expect(page).to have_content("Cofre: Sim")
    expect(page).to have_content("Acessível: Sim")
    expect(page).to have_content("Disponível: Não")
  end

  it "e deve preencher todos os campos" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100,has_bathroom: true, has_air_conditioning: true, inn: Inn.last)
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    click_on "Quarto Rosa"
    click_on "Editar"
    fill_in "Nome", with: ""
    fill_in "Descrição", with: ""
    fill_in "Dimensão", with: ""
    fill_in "Ocupação máxima", with: ""
    fill_in "Diária", with: ""
    click_on "Atualizar Quarto"

    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Dimensão não pode ficar em branco")
    expect(page).to have_content("Ocupação máxima não pode ficar em branco")
    expect(page).to have_content("Diária não pode ficar em branco")
  end

  it "e deve ser dono da pousada" do
    outro_dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
    outra_pousada = Inn.create!(owner: outro_dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    quarto = Room.create!(inn: outra_pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100.00, has_bathroom: true, has_balcony: false, has_air_conditioning: true, has_tv: true, has_closet: false, has_safe: false, is_accessible: false, is_available: true)
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada Estrela do Mar", corporate_name: "Pousada Estrela do Mar LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pem@email.com", address: "Rua do Mar", address_number: "200", neighborhood: "Jardim do Mar", state: "SP",city: "São Paulo", cep: "12345677", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    login_as dono
    
    visit root_path
    click_on "Pousadaria"
    click_on "Pousada do Aconchego"
    click_on "Quarto Simples"

    expect(page).not_to have_link("Editar")

  end
end
