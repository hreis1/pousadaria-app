require "rails_helper"

describe "Usuário registra pousada" do
  it "não está logado" do
    post inns_path, params: { inn: { trade_name: "Pousada Ribeiropolis"} }

    expect(response).to redirect_to(new_owner_session_path)
  end

  it "já possui uma pousada cadastrada" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", state: "São Paulo", neighborhood: "Liberdade", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    login_as dono

    post inns_path, params: { inn: { trade_name: "Pousada Itanhaem"} }

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("Você já possui uma pousada cadastrada")
    expect(Inn.last).to eq pousada
  end
end