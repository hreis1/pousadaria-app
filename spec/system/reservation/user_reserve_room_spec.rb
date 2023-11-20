require "rails_helper"

describe "Usuário reserva quarto" do
  it "e deve estar logado para isso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)

    visit root_path
    click_on "Pousada Ribeiropolis"
    within("div#room-#{Room.last.id}") do
      click_on "Reservar"
    end
    data_entrada = 0.day.from_now.strftime("%d/%m/%Y")
    data_saida = 3.days.from_now.strftime("%d/%m/%Y")
    fill_in "Data de entrada", with: data_entrada
    fill_in "Data de saída", with: data_saida
    fill_in "Quantidade de hóspedes", with: 2
    click_on "Verificar disponibilidade"
    click_on "Confirmar Reserva"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content("Para continuar, faça login ou registre-se.")
  end

  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, has_air_conditioning: true, has_tv: false, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    login_as hospede, scope: :user

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    visit root_path
    click_on "Pousada Ribeiropolis"
    within("div#room-#{Room.last.id}") do
      click_on "Reservar"
    end
    data_entrada = 2.day.from_now.strftime("%d/%m/%Y")
    data_saida = 5.days.from_now.strftime("%d/%m/%Y")
    fill_in "Data de entrada", with: data_entrada
    fill_in "Data de saída", with: data_saida
    fill_in "Quantidade de hóspedes", with: 2
    click_on "Verificar disponibilidade"
    click_on "Confirmar Reserva"

    expect(page).to have_content("Reserva efetuada com sucesso")
    expect(page).to have_content("Código da reserva: ABC12345")
    expect(page).to have_content("Reservas")
    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Check-in: #{Inn.last.checkin_time.strftime("%H:%M")}")
    expect(page).to have_content("Data de entrada: #{data_entrada}")
    expect(page).to have_content("Check-out: #{Inn.last.checkout_time.strftime("%H:%M")}")
    expect(page).to have_content("Data de saída: #{data_saida}")
    expect(page).to have_content("Total: R$ 300,00")
    expect(page).to have_content("Meios de pagamento: Dinheiro, cartão de crédito ou débito")
  end
end