require "rails_helper"

describe "index Inn API" do
  context "GET /inns" do
    it "com sucesso" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      get "/api/v1/inns"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 2
      expect(json_response.first["id"]).to eq Inn.first.id
      expect(json_response.first["trade_name"]).to eq Inn.first.trade_name
      expect(json_response.first).not_to include "owner_id"
      expect(json_response.first).not_to include "cnpj"
      expect(json_response.first).not_to include "phone"
      expect(json_response.first).not_to include "email"
      expect(json_response.first).not_to include "address"
      expect(json_response.first).not_to include "address_number"
      expect(json_response.first).not_to include "neighborhood"
      expect(json_response.first).not_to include "state"
      expect(json_response.first).not_to include "city"
      expect(json_response.first).not_to include "cep"
      expect(json_response.first).not_to include "description"
      expect(json_response.first).not_to include "payment_methods"
      expect(json_response.first).not_to include "pets_allowed"
      expect(json_response.first).not_to include "polices"
      expect(json_response.first).not_to include "checkin_time"
      expect(json_response.first).not_to include "checkout_time"
      expect(json_response.first).not_to include "created_at"
      expect(json_response.first).not_to include "updated_at"
      expect(json_response.last["id"]).to eq Inn.last.id
      expect(json_response.last["trade_name"]).to eq Inn.last.trade_name
    end
    it "sem resultados" do
      get "/api/v1/inns"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 0
      expect(json_response).to eq []
    end
    it "e não exibe inativos" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)

      get "/api/v1/inns"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 1
      expect(json_response.first["id"]).to eq Inn.first.id
      expect(json_response.first["trade_name"]).to eq Inn.first.trade_name
    end
    it "erro interno" do
      allow(Inn).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/inns"

      expect(response).to have_http_status(500)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["messagem"]).to eq "Erro interno"
    end
    it "com parâmetros" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")


      get "/api/v1/inns?trade_name=itanhaem"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 1
      expect(json_response.first["id"]).to eq Inn.last.id
      expect(json_response.first["trade_name"]).to eq Inn.last.trade_name
    end
    it "com parâmetros e sem resultados" do
      get "/api/v1/inns?trade_name=itanhaem"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 0
      expect(json_response).to eq []
    end
    it "com parâmetros e erro interno" do
      allow(Inn).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/inns?trade_name=itanhaem"

      expect(response).to have_http_status(500)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response["messagem"]).to eq "Erro interno"
    end
    it "com parâmetros e não exibe inativos" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

      dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
      Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Botafogo", state: "Rio de Janeiro", city: "Rio de Janeiro", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)

      get "/api/v1/inns?trade_name=pousada"

      expect(response).to have_http_status(200)
      expect(response.content_type).to include "application/json"
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 1
      expect(json_response.first["id"]).to eq Inn.first.id
      expect(json_response.first["trade_name"]).to eq Inn.first.trade_name
    end
  end
end


