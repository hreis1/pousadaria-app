require "rails_helper"

describe "Dono edita pousada" do
  it "deve estar logado" do
    visit root_path

    expect(page).not_to have_link("Minha Pousada")
  end

  it "com sucesso" do
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    click_on "Editar"
    fill_in "Nome Fantasia", with: "Pousada Encanto"
    fill_in "Razão Social", with: "Pousada Encanto LTDA"
    fill_in "CNPJ", with: "11109876543211"
    fill_in "Telefone de contato", with: "11988888888"
    fill_in "E-mail de contato", with: "pe@email.com"
    fill_in "Endereço", with: "Rua das Rosas"
    fill_in "Número", with: "200"
    fill_in "Bairro", with: "Jardim das Rosas"
    fill_in "Estado", with: "SP"
    fill_in "Cidade", with: "São Paulo"
    fill_in "CEP", with: "87654321"
    fill_in "Descrição", with: "Pousada para todos os gostos e bolsos"
    fill_in "Formas de pagamento", with: "Dinheiro, cartão de crédito ou débito"
    uncheck "Aceita pets"
    fill_in "Políticas", with: "Não aceitamos muito barulho"
    fill_in "Horário de checkin", with: "12:00"
    fill_in "Horário de checkout", with: "12:00"
    click_button "Atualizar Pousada"

    expect(current_path).to eq(inn_path(pousada))
    expect(page).to have_content("Pousada atualizada com sucesso")
    expect(page).to have_content("Pousada Encanto")
    expect(page).to have_content("Endereço: Rua das Rosas, 200, Jardim das Rosas, São Paulo - SP")
    expect(page).to have_content("Telefone de contato: 11988888888")
    expect(page).to have_content("E-mail de contato: pe@email.com")
    expect(page).to have_content("Descrição: Pousada para todos os gostos e bolsos")
    expect(page).to have_content("Formas de pagamento: Dinheiro, cartão de crédito ou débito")
    expect(page).to have_content("Aceita pets: Não")
    expect(page).to have_content("Políticas: Não aceitamos muito barulho")
    expect(page).to have_content("Horário de checkin: 12:00")
    expect(page).to have_content("Horário de checkout: 12:00")
    expect(page).to have_content("Ativa: Sim")
  end

  it "com campos em branco" do
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    login_as dono

    visit root_path
    click_on "Minha Pousada"
    click_on "Editar"
    fill_in "Nome Fantasia", with: ""
    fill_in "Razão Social", with: ""
    fill_in "CNPJ", with: ""
    fill_in "Telefone de contato", with: ""
    fill_in "E-mail de contato", with: ""
    fill_in "Endereço", with: ""
    fill_in "Número", with: ""
    fill_in "Bairro", with: ""
    fill_in "Estado", with: ""
    fill_in "Cidade", with: ""
    fill_in "CEP", with: ""
    fill_in "Descrição", with: ""
    fill_in "Formas de pagamento", with: ""
    fill_in "Políticas", with: ""
    fill_in "Horário de checkin", with: ""
    fill_in "Horário de checkout", with: ""
    click_button "Atualizar Pousada"
    
    expect(page).to have_content("Não foi possível atualizar a pousada")
    expect(page).to have_content("Nome Fantasia não pode ficar em branco")
    expect(page).to have_content("Razão Social não pode ficar em branco")
    expect(page).to have_content("CNPJ não pode ficar em branco")
    expect(page).to have_content("Telefone de contato não pode ficar em branco")
    expect(page).to have_content("E-mail de contato não pode ficar em branco")
    expect(page).to have_content("Endereço não pode ficar em branco")
    expect(page).to have_content("Número não pode ficar em branco")
    expect(page).to have_content("Bairro não pode ficar em branco")
    expect(page).to have_content("Estado não pode ficar em branco")
    expect(page).to have_content("Cidade não pode ficar em branco")
    expect(page).to have_content("CEP não pode ficar em branco")
    expect(page).to have_content("Descrição não pode ficar em branco")
    expect(page).to have_content("Formas de pagamento não pode ficar em branco")
    expect(page).to have_content("Políticas não pode ficar em branco")
    expect(page).to have_content("Horário de checkin não pode ficar em branco")
    expect(page).to have_content("Horário de checkout não pode ficar em branco")
  end

  it "e tenta editar outra pousada" do
    outro_dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
    outra_pousada = Inn.create!(owner: outro_dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
  
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    login_as dono
    
    visit edit_inn_path(outra_pousada)

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Você não tem permissão para acessar essa página")
  end

  it "edita situação da pousada" do
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
  
    login_as dono
    visit root_path
    click_on "Minha Pousada"
    click_on "Editar"
    uncheck "Ativa"
    click_button "Atualizar Pousada"

    expect(current_path).to eq(inn_path(pousada))
    expect(page).to have_content("Pousada atualizada com sucesso")
    expect(page).to have_content("Ativa: Não")
  end
end