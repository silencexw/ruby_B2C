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
    @transaction_order = TransactionOrder.create_order_from_cart_items!(current_user, address, cart_items)

    render template:  "transaction_orders/pay"
  end

  def pay
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.update(is_payed: true)
    redirect_to cart_items_path
  end

end
