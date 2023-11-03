require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe '#valid?' do
    context 'quando atributos não estão presentes' do
      it 'Nome Fantasia nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:trade_name)).to include('Nome Fantasia não pode ficar em branco')
      end

      it 'Razão Social nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:corporate_name)).to include('Razão Social não pode ficar em branco')
      end

      it 'CNPJ nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:cnpj)).to include('CNPJ não pode ficar em branco')
      end

      it 'Telefone de contato nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:phone)).to include('Telefone de contato não pode ficar em branco')
      end

      it 'E-mail de contato nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:email)).to include('E-mail de contato não pode ficar em branco')
      end

      it 'Endereço nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:address)).to include('Endereço não pode ficar em branco')
      end

      it 'Número do endereço nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:address_number)).to include('Número não pode ficar em branco')
      end

      it 'Bairro nao está presente' do
        pousada = Inn.new
        pousada.valid?
        
        expect(pousada.errors.full_messages_for(:neighborhood)).to include('Bairro não pode ficar em branco')
      end
        
      it 'Estado nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:state)).to include('Estado não pode ficar em branco')
      end

      it 'Cidade nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:city)).to include('Cidade não pode ficar em branco')
      end

      it 'CEP nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:cep)).to include('CEP não pode ficar em branco')
      end

      it 'Descrição nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:description)).to include('Descrição não pode ficar em branco')
      end

      it 'Formas de pagamento nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:payment_methods)).to include('Formas de pagamento não pode ficar em branco')
      end

      it 'Políticas nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:polices)).to include('Políticas não pode ficar em branco')
      end

      it 'Horário de checkin nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:checkin_time)).to include('Horário de checkin não pode ficar em branco')
      end

      it 'Horário de checkout nao está presente' do
        pousada = Inn.new
        pousada.valid?
      
        expect(pousada.errors.full_messages_for(:checkout_time)).to include('Horário de checkout não pode ficar em branco')
      end

      it 'Dono nao está presente' do
        pousada = Inn.new
        pousada.valid?

        expect(pousada.errors.full_messages_for(:owner)).to include('Dono é obrigatório(a)')
      end
    end

    context "quando atributos estão com formatos inválidos" do
      it 'CEP está em formato inválido' do
        pousada = Inn.new(cep: '123456789')
        pousada.valid?

        expect(pousada.errors.full_messages_for(:cep)).to include('CEP formato inválido')
      end

      it 'Telefone de contato está em formato inválido' do
        pousada = Inn.new(phone: '123456789')
        pousada.valid?

        expect(pousada.errors.full_messages_for(:phone)).to include('Telefone de contato formato inválido')
      end
    end

    context "quando informações já estão cadastradas" do
      it "CNPJ já está cadastrado" do
        dono = Owner.create!(email: "dono@email.com", password: "senhadono")
        Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade" ,state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
        
        pousada = Inn.new(cnpj: "12345678910111")
        pousada.valid?

        expect(pousada.errors.full_messages_for(:cnpj)).to include('CNPJ já está em uso')
      end

      it "Telefone de contato já está cadastrado" do
        dono = Owner.create!(email: "dono@email.com", password: "senhadono")
        Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
        pousada = Inn.new(phone: "11999999999")
        
        pousada.valid?
        expect(pousada.errors.full_messages_for(:phone)).to include('Telefone de contato já está em uso')
      end

      it "E-mail de contato já está cadastrado" do
        dono = Owner.create!(email: "dono@email.com", password: "senhadono")
        Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

        pousada = Inn.new(email: "pr@email.com")

        pousada.valid?
        expect(pousada.errors.full_messages_for(:email)).to include('E-mail de contato já está em uso')
      end

      it "Dono já possui uma pousada cadastrada" do
        dono = Owner.create!(email: "dono@email", password: "senhadono")

        Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
        
        outra_pousada = Inn.new(owner: dono, trade_name: "Pousada Estrela", corporate_name: "Pousada Estrela LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Estrelas", address_number: "1", state: "Paraná", city: "Curitiba", cep: "123456", description: "Pousada para todos os bolsos", payment_methods: "Dinheiro", pets_allowed: true, polices: "Não aceitamos muito barulho", checkin_time: "12:00", checkout_time: "12")

        outra_pousada.valid?
        expect(outra_pousada.errors.full_messages_for(:owner)).to include('Dono já possui uma pousada cadastrada')
      end
    end
    describe "#full_address" do
      it "retorna endereço completo" do
        dono = Owner.create!(email: "dono@email", password: "senhadono")
        pousada = Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood: "Liberdade",  state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

        expect(pousada.full_address).to eq("Rua dos Bobos, 0, Liberdade, São Paulo - São Paulo")
      end
    end
  end
end
