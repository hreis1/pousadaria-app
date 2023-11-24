require "rails_helper"

describe "Usuário cria conta" do
  it "com sucesso" do
    visit root_path
    click_on "Entrar como hóspede"
    click_on "Cadastre-se"
    fill_in "Nome completo", with: "Fulano de Tal"
    fill_in "E-mail", with: "hospede@email.com"
    fill_in "CPF", with: "12345678910"
    fill_in "Senha", with: "123456"
    fill_in "Confirmação de senha", with: "123456"
    click_on "Cadastrar"

    expect(current_path).to eq root_path
    expect(page).to have_content("Bem vindo! Você realizou seu registro com sucesso.")
    expect(page).to have_content("Fulano de Tal")
    expect(page).to have_button("Sair")
    expect(page).not_to have_link("Entrar como hóspede")
    expect(page).not_to have_link("Criar conta")
  end

  it "e não preenche todos os campos" do
    visit root_path
    click_on "Entrar como hóspede"
    click_on "Cadastre-se"
    fill_in "Nome completo", with: ""
    fill_in "E-mail", with: ""
    fill_in "CPF", with: ""
    fill_in "Senha", with: ""
    fill_in "Confirmação de senha", with: ""
    click_on "Cadastrar"

    expect(current_path).to eq user_registration_path
    expect(page).to have_content("Nome completo não pode ficar em branco")
    expect(page).to have_content("E-mail não pode ficar em branco")
    expect(page).to have_content("CPF não pode ficar em branco")
    expect(page).to have_content("Senha não pode ficar em branco")
  end
end