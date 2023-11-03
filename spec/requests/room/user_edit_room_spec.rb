require "rails_helper"

describe "Dono edita quarto" do
  context "deve estar logado" do
    it "tenta acessar a página de edição" do
      dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100.00, has_bathroom: true, has_balcony: false, has_air_conditioning: true, has_tv: true, has_closet: false, has_safe: false, is_accessible: false, is_available: true)

      get edit_inn_room_path(pousada, quarto)

      expect(response).to redirect_to(new_owner_session_path)
      expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    end

    it "tenta atualizar o quarto" do
      dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100.00, has_bathroom: true, has_balcony: false, has_air_conditioning: true, has_tv: true, has_closet: false, has_safe: false, is_accessible: false, is_available: true)

      patch inn_room_path(pousada, quarto), params: { room: { name: "Quarto Master" } }

      expect(response).to redirect_to(new_owner_session_path)
      expect(flash[:alert]).to eq("Para continuar, faça login ou registre-se.")
    end
  end

  context "está logado" do
    it "tenta acessar a página de edição do quarto de outra pousada" do
      outro_dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      outra_pousada = Inn.create!(owner: outro_dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: outra_pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100.00, has_bathroom: true, has_balcony: false, has_air_conditioning: true, has_tv: true, has_closet: false, has_safe: false, is_accessible: false, is_available: true)
      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Estrela do Mar", corporate_name: "Pousada Estrela do Mar LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pem@email.com", address: "Rua do Mar", address_number: "200", neighborhood: "Jardim do Mar", state: "SP",city: "São Paulo", cep: "12345677", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      login_as dono

      get edit_inn_room_path(outra_pousada, quarto)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Você não tem permissão para acessar essa página")
    end

    it "tenta atualizar o quarto de outra pousada" do
      outro_dono = Owner.create!(email: "outrodono@email.com", password: "senhaoutrodono")
      outra_pousada = Inn.create!(owner: outro_dono, trade_name: "Pousada do Aconchego", corporate_name: "Pousada do Aconchego LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pa@email.com", address: "Rua das Flores", address_number: "100", neighborhood: "Jardim das Flores", state: "SP",city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      quarto = Room.create!(inn: outra_pousada, name: "Quarto Simples", description: "Quarto simples com cama de casal", dimension: "20m²", max_occupancy: 2, daily_rate: 100.00, has_bathroom: true, has_balcony: false, has_air_conditioning: true, has_tv: true, has_closet: false, has_safe: false, is_accessible: false, is_available: true)
      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      pousada = Inn.create!(owner: dono, trade_name: "Pousada Estrela do Mar", corporate_name: "Pousada Estrela do Mar LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pem@email.com", address: "Rua do Mar", address_number: "200", neighborhood: "Jardim do Mar", state: "SP",city: "São Paulo", cep: "12345677", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      login_as dono

      patch inn_room_path(outra_pousada, quarto), params: { room: { name: "Quarto Master" } }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Você não tem permissão para acessar essa página")
    end
  end
end