require "rails_helper"

describe "Usuário cancela reserva" do
  it "com sucesso" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 9.day.from_now, checkout: 11.days.from_now, number_of_guests: 2)
    login_as hospede, scope: :user

    visit root_path
    click_on "Minhas reservas"
    click_on "Cancelar"

    expect(page).to have_content("Reserva cancelada com sucesso")
    expect(page).to have_content("Reservas")
    expect(page).to have_content("Quarto Rosa")
    expect(page).to have_content("Horário de checkin: #{Inn.last.checkin_time.strftime("%H:%M")}")
    expect(page).to have_content("Data de entrada: #{reserva.checkin.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Horário de checkout: #{Inn.last.checkout_time.strftime("%H:%M")}")
    expect(page).to have_content("Data de saída: #{reserva.checkout.strftime("%d/%m/%Y")}")
    expect(page).to have_content("Total: R$ 200,00")
    expect(page).to have_content("Formas de pagamento: Dinheiro, cartão de crédito ou débito")
    expect(page).to have_content("Situação: Cancelada")
  end

  it "e não consegue cancelar reserva com status diferente de pendente" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 2.day.from_now, checkout: 5.days.from_now, number_of_guests: 2, status: :canceled)
    login_as hospede, scope: :user

    visit root_path
    click_on "Minhas reservas"
    
    expect(page).not_to have_content("Cancelar")
  end

  it "e já está com menos de 7 dias para o checkin" do
    dono = Owner.create!(email: "d@email.com", password: "senhadono")
    Inn.create!(owner: dono, trade_name: "Pousada Ribeiropolis", corporate_name: "Pousada Ribeiropolis LTDA", cnpj: "12345678910111", phone: "11999999999", email: "pr@email.com", address: "Rua dos Bobos", address_number: "0", neighborhood:"Morumbi", state: "São Paulo", city: "São Paulo", cep: "12345678", description: "Pousada para todos os gostos", payment_methods: "Dinheiro, cartão de crédito ou débito", pets_allowed: true, polices: "Não aceitamos animais de grande porte", checkin_time: "12:00", checkout_time: "12:00")
    Room.create!(name: "Quarto Rosa", description: "Quarto com cama de casal, TV e ar condicionado", dimension: "20m²", max_occupancy: 2, daily_rate: 100, inn: Inn.last)
    hospede = User.create!(name: "Fulano de Tal", email: "fdt@email", cpf: "72139331023", password: "password")
    reserva = Reservation.create!(user: hospede, room: Room.last, code: "ABC12345", checkin: 2.day.from_now, checkout: 5.days.from_now, number_of_guests: 2)
    login_as hospede, scope: :user

    visit root_path
    click_on "Minhas reservas"
    
    expect(page).not_to have_content("Cancelar")
  end
end