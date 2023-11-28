require "rails_helper"

describe "Verifica a disponibilidade de um quarto" do
  context "GET /api/v1/inns/:inn_id/rooms/:room_id/check" do
    it "com sucesso" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)

      get "/api/v1/inns/#{Inn.last.id}/rooms/#{Room.last.id}/check", params: { checkin: 2.days.from_now.strftime("%Y/%m/%d"), checkout: 4.days.from_now.strftime("%Y/%m/%d"), number_of_guests: 2 }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include("application/json")
      json_response = JSON.parse(response.body)
      expect(json_response["price"]).to eq(200)
    end
    it "sem informar parâmetros" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)

      get "/api/v1/inns/#{Inn.last.id}/rooms/#{Room.last.id}/check"

      expect(response).to have_http_status(400)
      expect(response.content_type).to include("application/json")
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq("Parâmetros inválidos")
    end
    it "e quarto está indisponível" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last, is_available: false)

      get "/api/v1/inns/#{Inn.last.id}/rooms/#{Room.last.id}/check", params: { checkin: 2.days.from_now.strftime("%Y/%m/%d"), checkout: 4.days.from_now.strftime("%Y/%m/%d"), number_of_guests: 2 }

      expect(response).to have_http_status(404)
      expect(response.content_type).to include("application/json")
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq("Não encontrado")
    end
    it "e pousada está inativa" do
      dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
      Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00", active: false)
      Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)

      get "/api/v1/inns/#{Inn.last.id}/rooms/#{Room.last.id}/check", params: { checkin: 2.days.from_now.strftime("%Y/%m/%d"), checkout: 4.days.from_now.strftime("%Y/%m/%d"), number_of_guests: 2 }

      expect(response).to have_http_status(404)
      expect(response.content_type).to include("application/json")
      json_response = JSON.parse(response.body)
      expect(json_response["mensagem"]).to eq("Não encontrado")
    end
  end
end
