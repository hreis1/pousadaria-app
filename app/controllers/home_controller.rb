class HomeController < ApplicationController
  def index
    @inns = Inn.where(active: true).to_a
    @cities = Inn.pluck(:city).uniq
  end

  def cities
    @inns = Inn.where(city: params[:city], active: true).order(trade_name: :asc)
    @city = params[:city]
  end
end