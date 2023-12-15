class WelcomeController < ApplicationController
  def index
    @categories = Category.grouped_data
    @products = Product.onShelf.page(params[:page]).per_page(params[:per_page] || 12)
                       .order("id desc")
                       # .includes(:main_product_image)
  end
end
