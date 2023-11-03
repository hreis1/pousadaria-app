require "rails_helper"

describe "Usuário vê pousada" do
  it "não está logado" do
    get my_inn_path

    expect(response).to redirect_to(new_owner_session_path)
  end

  context "está logado" do
    it "é dono" do
      dono = Owner.create!(email: "dono@email", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      login_as dono

      get my_inn_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("Pousada Ribeiropolis")
    end

    it "não é dono" do
      outro_dono = Owner.create!(email: "outrodono@email", password: "senhaoutrodono")
      Inn.create!(owner: outro_dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dono = Owner.create!(email: "dono@email", password: "senhadono")
      login_as dono

      get my_inn_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Você não possui uma pousada cadastrada")
      expect(response.body).to_not include("Pousada Ribeiropolis")
    end
  end
end