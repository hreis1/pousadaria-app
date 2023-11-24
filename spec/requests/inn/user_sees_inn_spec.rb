require "rails_helper"

describe "Usuário vê pousada" do
  it "não está logado" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    get inn_path(1)

    expect(response).to have_http_status(200)
    expect(response.body).to include("Pousada Ribeiropolis")
  end

  it "tenta vê pousada inativa" do
    dono = Owner.create!(email: "dono@email", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)

    get inn_path(1)

    expect(flash[:alert]).to eq "Pousada inativa"
    expect(response).to redirect_to root_path
  end

  it "e tenta vê pousada inexistente" do
    get inn_path(1)

    expect(flash[:alert]).to eq "Pousada não encontrada"
    expect(response).to redirect_to root_path
  end

  context "está logado" do
    it "é dono" do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      login_as dono

      get inn_path(1)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Pousada Ribeiropolis")
    end

    it "é dono e tenta vê pousada inativa" do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)
      login_as dono

      get inn_path(1)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Pousada Ribeiropolis")
    end
  end
end