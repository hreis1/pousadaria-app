require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "#valid?" do
    context "quando atributos não estão presentes" do
      it "Nome não está presente" do
        quarto = Room.new
        quarto.valid?

        expect(quarto.errors.full_messages_for(:name)).to include("Nome não pode ficar em branco")
      end

      it "Pousada não está presente" do
        quarto = Room.new
        quarto.valid?

        expect(quarto.errors.full_messages_for(:inn)).to include("Pousada é obrigatório(a)")
      end

      it "Dimensão não está presente" do
        quarto = Room.new
        quarto.valid?

        expect(quarto.errors.full_messages_for(:dimension)).to include("Dimensão não pode ficar em branco")
      end

      it "Descrição não está presente" do
        quarto = Room.new
        quarto.valid?

        expect(quarto.errors.full_messages_for(:description)).to include("Descrição não pode ficar em branco")
      end

      it "Ocupação máxima não pode ser 0" do
        quarto = Room.new(max_occupancy: 0)
        quarto.valid?

        expect(quarto.errors.full_messages_for(:max_occupancy)).to include("Ocupação máxima deve ser maior que 0")
      end

      it "Oucupação máxima não pode ser negativa" do
        quarto = Room.new(max_occupancy: -1)
        quarto.valid?

        expect(quarto.errors.full_messages_for(:max_occupancy)).to include("Ocupação máxima deve ser maior que 0")
      end

      it "Diária não está presente" do
        quarto = Room.new
        quarto.valid?

        expect(quarto.errors.full_messages_for(:daily_rate)).to include("Diária não pode ficar em branco")
      end

      it "Diária não pode ser 0" do
        quarto = Room.new(daily_rate: 0)
        quarto.valid?

        expect(quarto.errors.full_messages_for(:daily_rate)).to include("Diária deve ser maior que 0")
      end

      it "Diária não pode ser negativa" do
        quarto = Room.new(daily_rate: -1)
        quarto.valid?

        expect(quarto.errors.full_messages_for(:daily_rate)).to include("Diária deve ser maior que 0")
      end
    end
  end

  describe "#is_available?" do
    it "Quando quarto está disponível" do
      quarto = Room.new(is_available: true)

      expect(quarto.is_available?).to eq true
    end

    it "Quando quarto não está disponível" do
      quarto = Room.new(is_available: false)

      expect(quarto.is_available?).to eq false
    end
  end
end


