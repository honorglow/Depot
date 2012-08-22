class StoreController < ApplicationController
  def index
    increment_counter
    @products = Product.order(:title)
    @show_message = "Viewed page " + session[:counter].to_s + " times." if session[:counter] > 5
  end

  def increment_counter
    if session[:counter].nil?
      session[:counter] = 0
    end
    session[:counter] += 1
  end

end
