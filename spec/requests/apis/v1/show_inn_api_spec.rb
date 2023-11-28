require "rails_helper"

describe "show Inn API" do
  context "GET /api/v1/inns/:id" do
    it "com sucesso" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      get "/api/v1/inns/#{Inn.first.id}"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response).not_to include "cnpj"
      expect(json_response).not_to include "corporate_name"
      expect(json_response).not_to include "created_at"
      expect(json_response).not_to include "updated_at"
      expect(json_response["id"]).to eq Inn.first.id
      expect(json_response["trade_name"]).to eq Inn.first.trade_name
      expect(json_response["owner_id"]).to eq Inn.first.owner_id
      expect(json_response["phone"]).to eq Inn.first.phone
      expect(json_response["email"]).to eq Inn.first.email
      expect(json_response["address"]).to eq Inn.first.address
      expect(json_response["address_number"]).to eq Inn.first.address_number
      expect(json_response["neighborhood"]).to eq Inn.first.neighborhood
      expect(json_response["state"]).to eq Inn.first.state
      expect(json_response["city"]).to eq Inn.first.city
      expect(json_response["cep"]).to eq Inn.first.cep
      expect(json_response["description"]).to eq Inn.first.description
      expect(json_response["payment_methods"]).to eq Inn.first.payment_methods
      expect(json_response["pets_allowed"]).to eq Inn.first.pets_allowed
      expect(json_response["polices"]).to eq Inn.first.polices
      expect(json_response["checkin_time"]).to eq Inn.first.checkin_time.strftime("%H:%M")
      expect(json_response["checkout_time"]).to eq Inn.first.checkout_time.strftime("%H:%M")
    end
    it "com id inválido" do
      get "/api/v1/inns/999999999"

      expect(response).to have_http_status(404)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq "Não encontrado"
    end
    it "e pousada inativa" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)

      get "/api/v1/inns/#{Inn.first.id}"

      expect(response).to have_http_status(404)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq "Não encontrado"
    end
    it "erro interno" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      
      allow(Inn).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/inns/1"

      expect(response).to have_http_status(500)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      
      expect(json_response["mensagem"]).to eq "Erro interno"
    end
    pending "e existem avaliações"
    pending "e não existem avaliações"
  end
end


