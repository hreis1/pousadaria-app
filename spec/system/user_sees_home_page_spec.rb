require "rails_helper"

describe "Usuário vê a página inicial" do
  it "com sucesso" do
    visit root_path
    expect(page).to have_content "Pousadaria"
  end
end