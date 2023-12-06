class CartItemsController < ApplicationController
  before_action :get_cart_item, only: [:update, :destroy]

  def index
    @cart_items = CartItem.find_by_user_id(session[:user_id])
                          .order(id: "desc").includes(:product_item)
  end

  def create
    if logged_in?
      amount = params[:amount].to_i
      amount = amount <= 0 ? 1 : amount

      @product_item = ProductItem.find(params[:product_item_id])
      @product = Product.find(@product_item.product_id)
      @cart_item = CartItem.create_or_update!({
                                                user_id: session[:user_id],
                                                product_item_id: params[:product_item_id],
                                                amount: amount,
                                              })

      redirect_to product_path(@product), notice: "加入购物车成功"
    else
      flash[:error] = "请先登录"
      redirect_to new_session_path
    end
  end


  def update
    if @cart_item
      amount = params[:amount].to_i || 1
      @cart_item.update!(amount: amount)
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


end
