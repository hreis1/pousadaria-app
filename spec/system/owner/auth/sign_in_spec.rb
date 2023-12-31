require "rails_helper"

describe "Dono da pousada inicia sessão" do
  it "com sucesso" do
    owner = Owner.create!(email: "dono@email.com", password: "senhadono")

    visit root_path
    click_on "Entrar como dono de pousada"

    fill_in "E-mail", with: owner.email
    fill_in "Senha", with: owner.password
    click_on "Entrar"
    
    expect(page).to have_button "Sair"
    expect(page).to have_content "Você precisa cadastrar uma pousada para continuar."
    expect(page).not_to have_link "Entrar como dono de pousada"
  end

  it "e sai da sessão" do
    owner = Owner.create!(email: "dono@email.com", password: "senhadono")

    login_as owner
    visit root_path
    click_on "Sair"

    expect(page).to have_content "Logout efetuado com sucesso."
    expect(page).to have_link "Entrar como dono de pousada"
    expect(page).not_to have_button "Sair"
  end

  it "e não pode acessar a página de login" do
    owner = Owner.create!(email: "dono@email.com", password: "senhadono")

    login_as owner
    visit new_owner_session_path

    expect(current_path).to eq new_inn_path
    expect(page).not_to have_link "Entrar como dono de pousada"
  end

  it "e não pode acessar a página de cadastro" do
    owner = Owner.create!(email: "dono@email.com", password: "senhadono")

    login_as owner
    visit new_owner_registration_path

    expect(current_path).to eq new_inn_path
    expect(page).to have_content "Você precisa cadastrar uma pousada para continuar."
  end
end