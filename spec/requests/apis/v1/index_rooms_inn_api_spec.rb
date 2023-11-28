require "rails_helper"

describe "index Room API" do
  context "GET /api/v1/inns/:inn_id/rooms" do
    it "com sucesso" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      Room.create!(name: "Suíte Azul", description: "Suíte com cama de casal, TV e ar condicionado", dimension: "30m²", max_occupancy: 2, daily_rate: 150, has_bathroom: true, has_balcony: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)

      get "/api/v1/inns/#{Inn.last.id}/rooms"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq 2
      expect(json_response.first).not_to include "created_at"
      expect(json_response.first).not_to include "updated_at"
      expect(json_response.first).not_to include "is_available"
      expect(json_response.first["name"]).to eq "Quarto Rosa"
      expect(json_response.first["description"]).to eq "Quarto com cama de casal, TV e ar condicionado"
      expect(json_response.first["dimension"]).to eq 20
      expect(json_response.first["max_occupancy"]).to eq 2
      expect(json_response.first["daily_rate"]).to eq 100
      expect(json_response.first["has_balcony"]).to eq false
      expect(json_response.first["has_air_conditioning"]).to eq true
      expect(json_response.first["has_tv"]).to eq false
      expect(json_response.first["has_closet"]).to eq false
      expect(json_response.first["has_safe"]).to eq false
      expect(json_response.first["is_accessible"]).to eq false

      expect(json_response.last).not_to include "created_at"
      expect(json_response.last).not_to include "updated_at"
      expect(json_response.last).not_to include "is_available"
      expect(json_response.last["name"]).to eq "Suíte Azul"
      expect(json_response.last["description"]).to eq "Suíte com cama de casal, TV e ar condicionado"
      expect(json_response.last["dimension"]).to eq 30
      expect(json_response.last["max_occupancy"]).to eq 2
      expect(json_response.last["daily_rate"]).to eq 150
      expect(json_response.last["has_balcony"]).to eq true
      expect(json_response.last["has_air_conditioning"]).to eq true
      expect(json_response.last["has_tv"]).to eq true
      expect(json_response.last["has_closet"]).to eq true
      expect(json_response.last["has_safe"]).to eq true
      expect(json_response.last["is_accessible"]).to eq true
    end
    it "e não há quartos cadastrados" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      get "/api/v1/inns/#{Inn.last.id}/rooms"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end
    it "e o id da pousada não existe" do
      get "/api/v1/inns/999/rooms"

      expect(response).to have_http_status(404)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq "Não encontrado"
    end
    it "e não visualiza quartos de outra pousada" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Família", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 4, daily_rate: 100, has_bathroom: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)
      
      get "/api/v1/inns/#{Inn.last.id}/rooms"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq 1
      expect(json_response.first["name"]).to eq "Quarto Família"
    end
    it "e não visualiza quartos de pousada inativa" do
      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)
      Room.create!(name: "Quarto Família", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 4, daily_rate: 100, has_bathroom: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last)

      get "/api/v1/inns/#{Inn.last.id}/rooms"

      expect(response).to have_http_status(404)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq "Não encontrado"
    end
    it "e visualiza não visualiza quartos inativos" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      Room.create!(name: "Suíte Azul", description: "Suíte com cama de casal, TV e ar condicionado", dimension: "30m²", max_occupancy: 2, daily_rate: 150, has_bathroom: true, has_balcony: true, has_air_conditioning: true, has_tv: true, has_closet: true, has_safe: true, is_accessible: true, inn: Inn.last, is_available: false)

      get "/api/v1/inns/#{Inn.last.id}/rooms"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq 1
      expect(json_response.first["name"]).to eq "Quarto Rosa"
    end
    it "erro interno do servidor" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
      
      allow_any_instance_of(Room).to receive(:as_json).and_raise(StandardError.new())

      get "/api/v1/inns/#{Inn.last.id}/rooms"

      expect(response).to have_http_status(500)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq "Erro interno"
    end
  end
end