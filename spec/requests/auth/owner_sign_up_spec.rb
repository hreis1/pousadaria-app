require "rails_helper"

describe "Dono da pousada se cadastra", type: :request do
  it "com sucesso" do

    post owner_registration_path, params: { owner: { email: "dono@email.com", password: "senhadono", password_confirmation: "senhadono"}}

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("Bem vindo! Você realizou seu registro com sucesso.")
    expect(Owner.last.email).to eq("dono@email.com")
  end

  it "e tenta acessar página de cadastro" do
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    login_as dono

    get new_owner_registration_path

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("Você já está autenticado.")
  end

  it "e tenta acessar página de login" do
    dono = Owner.create!(email: "dono@email.com", password: "senhadono")
    login_as dono

    get new_owner_session_path

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("Você já está autenticado.")
  end

  it "e é redirecionado para a página de cadastro de pousada" do
    dono = Owner.create!(email: "dono@email.com", password:"senhadono")
    login_as dono

    get root_path

    expect(response).to redirect_to(new_inn_path)
    expect(flash[:alert]).to eq("Você precisa cadastrar uma pousada para continuar.")
  end
end