require "rails_helper"


describe "Usuário busca por Pousada" do
  it "a partir da home page" do
    visit root_path

    within "header nav" do
      expect(page).to have_field("query", type: "text")
      expect(page).to have_button("Buscar")
    end
  end

  it "e acha mais de uma" do
    dono_a = Owner.create!(email: "a@email.com", password: "senhadonoa")
    Inn.create!(owner: dono_a, trade_name: "Pousada Enseada", corporate_name: "Pousada Enseada LTDA", cnpj: "12345678910112", phone: "11999999998", email: "pe@email.com", address: "Avenida das Margaridas", address_number: "10", neighborhood:"Enseada", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    dona_b = Owner.create!(email: "b@email.com", password: "senhadonob")
    Inn.create!(owner: dona_b, trade_name: "Pousada Itanhaem", corporate_name: "Pousada Itanhaem LTDA", cnpj: "12345678910113", phone: "11999999997", email: "pi@email.com", address: "Rua das Violetas", address_number: "13", neighborhood:"Itanhaem", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")

    visit root_path
    within "header nav" do
      fill_in "query", with: "Pou"
      click_on "Buscar"
    end

    expect(page).to have_content("2 pousadas encontradas")
    expect(page).to have_content("Pousada Enseada")
    expect(page).to have_content("Pousada Itanhaem")
  end

  it 'e não acha nada' do
    visit root_path

    within "header nav" do
      fill_in "query", with: "Pousada"
      click_on "Buscar"
    end

    expect(page).to have_content("Nenhuma pousada encontrada")
  end

  it 'não preenche nada' do
    visit root_path

    within "header nav" do
      fill_in "query", with: ""
      click_on "Buscar"
    end

    expect(page).to have_content("Digite o Nome da Pousada")
  end
end
