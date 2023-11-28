class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  
  private

  def internal_server_error
    render status:500, json: {menssagem: "Erro interno"}
  end

  def not_found_error
    render status:404, json: {mensagem: "Pousada não encontrada"}
  end
end