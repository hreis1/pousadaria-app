require "rails_helper"

describe "Dono registra pousada" do
  it "se não estiver logado" do
    visit new_inn_path

    expect(current_path).to eq(new_owner_session_path)
  end

  it "se estiver logado" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    login_as dono

    visit root_path

    expect(page).to have_link("Cadastrar pousada")
  end

  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    login_as dono

    visit root_path
    click_on "Cadastrar pousada"
    fill_in "Nome Fantasia", with: "Pousada Ribeiropolis"
    fill_in "Razão Social", with: "Pousada Ribeiropolis LTDA"
    fill_in "CNPJ", with: "12345678910111"
    fill_in "E-mail de contato", with: "pr@email.com"
    fill_in "Telefone de contato", with: "11999999999"
    fill_in "Endereço", with: "Rua dos Bobos"
    fill_in "Número", with: "0"
    fill_in "Bairro", with: "Centro"
    fill_in "Estado", with: "São Paulo"
    fill_in "Cidade", with: "São Paulo"
    fill_in "CEP", with: "12345678"
    fill_in "Descrição", with: "Pousada para todos os gostos"
    fill_in "Formas de pagamento", with: "Dinheiro, cartão de crédito e débito"
    check "Aceita pets"
    fill_in "Políticas", with: "Não aceitamos animais de grande porte"
    fill_in "Horário de checkin", with: "12:00"
    fill_in "Horário de checkout", with: "12:00"
    click_on "Cadastrar"

    expect(current_path).to eq(inn_path(Inn.last))
    expect(page).to have_content("Pousada Ribeiropolis")
    expect(page).to have_content("Endereço: Rua dos Bobos, 0, Centro, São Paulo - São Paulo")
    expect(page).to have_content("Telefone de contato: 11999999999")
    expect(page).to have_content("E-mail de contato: pr@email")
    expect(page).to have_content("Descrição: Pousada para todos os gostos")
    expect(page).to have_content("Formas de pagamento: Dinheiro, cartão de crédito e débito")
    expect(page).to have_content("Aceita pets: Sim")
    expect(page).to have_content("Políticas: Não aceitamos animais de grande porte")
    expect(page).to have_content("Horário de checkin: 12:00")
    expect(page).to have_content("Horário de checkout: 12:00")
  end
end