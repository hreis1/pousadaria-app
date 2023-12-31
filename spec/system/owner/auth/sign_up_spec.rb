require "rails_helper"

describe "Dono da pousada se cadastra" do
  it "com sucesso" do
    visit root_path
    click_on "Entrar como dono de pousada"
    click_on "Cadastre-se"

    fill_in "E-mail", with: "dono@email.com"
    fill_in "Senha", with: "senhadono"
    fill_in "Confirme sua senha", with: "senhadono"
    click_on "Cadastrar"
    
    expect(current_path).to eq new_inn_path
    expect(Owner.count).to eq 1
  end

  it "email inválido" do
    visit root_path
    click_on "Entrar como dono de pousada"
    click_on "Cadastre-se"

    fill_in "E-mail", with: "donoemail.com"
    fill_in "Senha", with: "senhadono"
    fill_in "Confirme sua senha", with: "senhadono"
    click_on "Cadastrar"

    expect(Owner.count).to eq 0
    expect(page).to have_content "E-mail não é válido"
  end

  it "senha e confirmação diferentes" do
    visit root_path
    click_on "Entrar como dono de pousada"
    click_on "Cadastre-se"

    fill_in "E-mail", with: "dono@email.com"
    fill_in "Senha", with: "senhadono"
    fill_in "Confirme sua senha", with: "senhadiferente"
    click_on "Cadastrar"

    expect(Owner.count).to eq 0
    expect(page).to have_content "Confirme sua senha não é igual a Senha"
  end

  it "senha menor que 6 caracteres" do
    visit root_path
    click_on "Entrar como dono de pousada"
    click_on "Cadastre-se"

    fill_in "E-mail", with: "donoemail.com"
    fill_in "Senha", with: "12345"
    fill_in "Confirme sua senha", with: "12345"
    click_on "Cadastrar"

    expect(Owner.count).to eq 0
    expect(page).to have_content "Senha é muito curto (mínimo: 6 caracteres)"
  end

  it "email já cadastrado" do
    owner = Owner.create!(email: "dono@email.com", password: "senhadono")

    visit root_path
    click_on "Entrar como dono de pousada"
    click_on "Cadastre-se"

    fill_in "E-mail", with: owner.email
    fill_in "Senha", with: "senhadono"
    fill_in "Confirme sua senha", with: "senhadono"
    click_on "Cadastrar"

    expect(Owner.count).to eq 1
    expect(page).to have_content "E-mail já está em uso"
  end

  it "campos em branco" do
    visit root_path
    click_on "Entrar como dono de pousada"
    click_on "Cadastre-se"

    fill_in "E-mail", with: ""
    fill_in "Senha", with: ""
    fill_in "Confirme sua senha", with: ""
    click_on "Cadastrar"

    expect(Owner.count).to eq 0
    expect(page).to have_content "E-mail não pode ficar em branco"
    expect(page).to have_content "Senha não pode ficar em branco"
  end
end