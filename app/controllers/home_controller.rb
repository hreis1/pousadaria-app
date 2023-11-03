class HomeController < ApplicationController
  def index
    @inns = Inn.all.where(active: true)
  end
end