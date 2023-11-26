class CartItemsController < ApplicationController
  before_action :get_cart_item, only: [:update, :destroy]

  def index
    @cart_items = CartItem.find_by_user_id(session[:user_id])
                          .order(id: "desc").includes([:product => [:main_product_image]])
  end

  def create
    if logged_in?
      amount = params[:amount].to_i
      amount = amount <= 0 ? 1 : amount

      @product = Product.find(params[:product_id])
      @cart_item = CartItem.create_or_update!({
                                                user_id: session[:user_id],
                                                product_id: params[:product_id],
                                                amount: amount
                                              })

      render layout: false
    else
      flash[:error] = "请先登录"
      render layout: false
    end
  end


  def update
    if @cart_item
      amount = params[:amount].to_i || 1
      @cart_item.update(amount: amount)
    end

    redirect_to cart_items_path
  end

  def destroy
    @cart_item.destroy if @cart_item

    redirect_to cart_items_path
  end

  private
  def get_cart_item
    @cart_item = CartItem.find_by_user_id(session[:user_id])
                                 .where(id: params[:id]).first
  end

  def redirect_to_back_with_error_message
    request.env["HTTP_REFERER"] ||= root_path
    redirect_to request.env["HTTP_REFERER"]
  end

end
