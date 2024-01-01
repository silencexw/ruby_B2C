class WelcomeController < ApplicationController
  def index
    @categories = Category.grouped_data
    case params[:order_option]

    when "time"
      @products = Product.onShelf.page(params[:page]).per_page(params[:per_page] || 12)
                         .order("id desc")
    when "num"
      @products = Product.onShelf.page(params[:page]).per_page(params[:per_page] || 12)
                         .order("sale_num desc")
    when "msrp"
      @products = Product.onShelf.page(params[:page]).per_page(params[:per_page] || 12)
                         .order("price desc")
    else
      @products = Product.onShelf.page(params[:page]).per_page(params[:per_page] || 12)
                         .order("id desc")
    end
  end
end
