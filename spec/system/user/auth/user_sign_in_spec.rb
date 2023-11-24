require "rails_helper"


describe "Hóspede faz login" do
  it "com sucesso" do
    hospede = User.create!(name: "Hóspede da Silva", email: "hds@email.com", cpf: "12345678910", password: "senhahospede")

    visit root_path
    click_on "Entrar como hóspede"

    fill_in "E-mail", with: hospede.email
    fill_in "Senha", with: hospede.password
    click_on "Entrar"

    expect(page).to have_content "Login efetuado com sucesso."
    expect(page).to have_button "Sair"
    expect(page).not_to have_link "Entrar como hóspede"
  end

  it "e sai da sessão" do
    hospede = User.create!(name: "Hóspede da Silva", email: "hds@email.com", cpf: "12345678910", password: "senhahospede")

    login_as hospede, scope: :user
    visit root_path
    click_on "Sair"

    expect(page).to have_content "Logout efetuado com sucesso."
    expect(page).to have_link "Entrar como hóspede"
    expect(page).not_to have_button "Sair"
  end

  it "e não pode acessar a página de login" do    
    hospede = User.create!(name: "Hóspede da Silva", email: "hds@email.com", cpf: "12345678910", password: "senhahospede")

    login_as hospede, scope: :user
    visit new_user_session_path

    expect(current_path).to eq root_path
    expect(page).to have_content "Você já está autenticado."
    expect(page).not_to have_link "Entrar como hóspede"
  end

  it "e não pode acessar a página de cadastro" do
    hospede = User.create!(name: "Hóspede da Silva", email: "hds@email.com", cpf: "12345678910", password: "senhahospede")

    login_as hospede, scope: :user
    visit new_user_registration_path

    expect(current_path).to eq root_path
    expect(page).to have_content "Você já está autenticado."
    expect(page).not_to have_link "Entrar como hóspede"
  end
end