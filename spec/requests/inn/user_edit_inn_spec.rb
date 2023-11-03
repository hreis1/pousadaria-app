require "rails_helper"

describe "Dono edita pousada" do
  context "deve estar logado" do
    it "tenta acessar a página de edição" do
      dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      
      get edit_inn_path(pousada)

      expect(response).to redirect_to(new_owner_session_path)
    end

    it "tenta atualizar a pousada" do
      dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      
      patch inn_path(pousada), params: { inn: { trade_name: "Pousada Encanto" } }

      expect(response).to redirect_to(new_owner_session_path)
    end
  end

  context "está logado" do
    it "tenta acessar a página de edição da pousada de outro dono" do
      outro_dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      outra_pousada = Inn.create!(owner: outro_dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      login_as dono

      get edit_inn_path(outra_pousada)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Você não tem permissão para acessar essa página")
    end

    it "tenta atualizar a pousada de outro dono" do
      outro_dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      outra_pousada = Inn.create!(owner: outro_dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      login_as dono

      patch inn_path(outra_pousada), params: { inn: { trade_name: "Pousada Encanto" } }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Você não tem permissão para acessar essa página")
    end
  end
end
