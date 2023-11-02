require "rails_helper"

describe "Usuário registra pousada" do
  it "e não está logado" do
    post inns_path, params: { inn: { trade_name: "Pousada Ribeiropolis"} }

    expect(response).to redirect_to(new_owner_session_path)
  end
end