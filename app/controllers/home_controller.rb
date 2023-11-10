class HomeController < ApplicationController
  def index
    @inns = Inn.all.where(active: true).to_a
  end
end