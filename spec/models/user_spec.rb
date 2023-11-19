require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    context "quantos atributos não estão presentes" do
      it "Nome não está presente" do
        user = User.new
        user.valid?

        expect(user.errors.full_messages_for(:name)).to include("Nome completo não pode ficar em branco")
      end

      it "E-mail não está presente" do
        user = User.new
        user.valid?

        expect(user.errors.full_messages_for(:email)).to include("E-mail não pode ficar em branco")
      end

      it "CPF não está presente" do
        user = User.new
        user.valid?

        expect(user.errors.full_messages_for(:cpf)).to include("CPF não pode ficar em branco")
      end
      
      it "Senha não está presente" do
        user = User.new
        user.valid?

        expect(user.errors.full_messages_for(:password)).to include("Senha não pode ficar em branco")
      end
    end

    it "CPF tamanho diferente de 11" do
      user = User.new(cpf: "123456789")
      user.valid?

      expect(user.errors.full_messages_for(:cpf)).to include("CPF não possui o tamanho esperado (11 caracteres)")
    end
    
    it "CPF já está em uso" do
      User.create!(name: "Fulano de Tal", cpf: "12345678910", email: "fdt@email.com", password: "senhafulano")
      user = User.new(cpf: "12345678910")
      user.valid?

      expect(user.errors.full_messages_for(:cpf)).to include("CPF já está em uso")
    end

    it "E-mail já está em uso" do
      User.create!(name: "Hospede da Silva", cpf: "10987654321", email: "hds@email.com", password: "senhahospede")
      user = User.new(email: "hds@email.com")
      user.valid?

      expect(user.errors.full_messages_for(:email)).to include("E-mail já está em uso")
    end
  end
end
