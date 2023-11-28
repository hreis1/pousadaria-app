class Api::V1::ApiController < ActionController::API
  rescue_from StandardError, with: :internal_server_error
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error


  private
  
  def not_found_error
    render status:404, json: {mensagem: "Não encontrado"}
  end
  
  def internal_server_error
    render status:500, json: {mensagem: "Erro interno"}
  end
end