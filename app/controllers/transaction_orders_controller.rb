class TransactionOrdersController < ApplicationController
  before_action :confirm_user

  def new
    @cart_items = CartItem.find_by_user_id(current_user.id)
                                  .order(id: "desc").includes([:product => [:main_product_image]])
  end

  def create
    cart_items = CartItem.find_by_user_id(current_user.id).includes(:product)
    if cart_items.blank?
      redirect_to cart_items_path
      return
    end

    address = current_user.addresses.find(params[:address_id])
    TransactionOrder.create_order_from_cart_items!(current_user, address, cart_items)

    redirect_to cart_items_path
  end
end
