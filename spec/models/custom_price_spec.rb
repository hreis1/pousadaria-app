require 'rails_helper'

RSpec.describe CustomPrice, type: :model do
  describe "#valid?" do
    context "quando campos obrigatórios não são preenchidos" do
      it "quando data de início não é preenchida" do
        custom_price = CustomPrice.new(start_date: nil, end_date: Date.tomorrow)

        expect(custom_price).to_not be_valid
        expect(custom_price.errors[:start_date]).to include("não pode ficar em branco")
      end

      it "quando data de término não é preenchida" do
        custom_price = CustomPrice.new(start_date: Date.today, end_date: nil)
        
        expect(custom_price).to_not be_valid
        expect(custom_price.errors[:end_date]).to include("não pode ficar em branco")
      end

      it "quando preço não é preenchido" do
        custom_price = CustomPrice.new(start_date: Date.today, end_date: Date.tomorrow, price: nil)

        expect(custom_price).to_not be_valid
        expect(custom_price.errors[:price]).to include("não pode ficar em branco")
      end

      it "quando quarto não é preenchido" do
        custom_price = CustomPrice.new(start_date: Date.today, end_date: Date.tomorrow, price: 100, room_id: nil)

        expect(custom_price).to_not be_valid
        expect(custom_price.errors[:room]).to include("é obrigatório(a)")
      end
    end

    it "quando data de início é maior que data de término" do
      custom_price = CustomPrice.new(start_date: Date.today, end_date: 1.day.ago)

      expect(custom_price).to_not be_valid
      expect(custom_price.errors[:start_date]).to include("deve ser menor que a data final")
    end
    
    it "quando data de início é igual a data de término" do
      custom_price = CustomPrice.new(start_date: Date.today, end_date: Date.today)
      
      custom_price.valid?
      expect(custom_price.errors[:start_date]).to include("deve ser menor que a data final")
    end

    it "quando preço é menor ou igual a zero" do
      custom_price = CustomPrice.new(start_date: Date.today, end_date: Date.tomorrow, price: 0)

      expect(custom_price).to_not be_valid
      expect(custom_price.errors[:price]).to include("deve ser maior que 0")
    end

    it "quando já existe um preço personalizado para o quarto na mesma data" do
      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Teste", description: "Quarto simples com cama de casal", max_occupancy:2, dimension:25, daily_rate: 100, inn: Inn.last)
      CustomPrice.create!(start_date: 2.day.ago, end_date: 2.day.from_now, price: 100, room: Room.last)
      custom_price = CustomPrice.new(start_date: 1.day.ago, end_date: 1.day.from_now, price: 200, room: Room.last)

      expect(custom_price).to_not be_valid
      expect(custom_price.errors[:base]).to include("Já existe um preço personalizado para o quarto na mesma data")

    end
  
    it "quando data de início já está dentro de um período de preço personalizado" do
      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Teste", description: "Quarto simples com cama de casal", max_occupancy:2, dimension:25, daily_rate: 100, inn: Inn.last)
      CustomPrice.create!(start_date: 2.day.ago, end_date: 2.day.from_now, price: 100, room: Room.last)
      custom_price = CustomPrice.new(start_date: 1.day.ago, end_date: 3.day.from_now, price: 200, room: Room.last)

      expect(custom_price).to_not be_valid
      expect(custom_price.errors[:base]).to include("Já existe um preço personalizado para o quarto na mesma data")
    end

    it "quando data de término já está dentro de um período de preço personalizado" do
      dono = Owner.create!(email: "dono@email.com", password: "senhadono")
      Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
      Room.create!(name: "Quarto Teste", description: "Quarto simples com cama de casal", max_occupancy:2, dimension:25, daily_rate: 100, inn: Inn.last)
      CustomPrice.create!(start_date: 2.day.from_now, end_date: 3.day.from_now, price: 100, room: Room.last)
      custom_price = CustomPrice.new(start_date: 1.day.ago, end_date: 2.day.from_now, price: 200, room: Room.last)

      expect(custom_price).to_not be_valid
      expect(custom_price.errors[:base]).to include("Já existe um preço personalizado para o quarto na mesma data")
    end
  end
end
