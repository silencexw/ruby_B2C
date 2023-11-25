class ProductsController < ApplicationController
  def show
    @user_id = session[:user_id]
    @categories = Category.grouped_data
    @product = Product.find(params[:id])
  end
end
