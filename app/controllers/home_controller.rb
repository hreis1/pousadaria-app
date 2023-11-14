class HomeController < ApplicationController
  def index
    @inns = Inn.all.where(active: true).to_a
    @cities = Inn.all.pluck(:city).uniq
  end

  def cities
    @inns = Inn.all.where(city: params[:city]).where(active: true).order(trade_name: :desc)
    @city = params[:city]
  end
end