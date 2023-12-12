class TransactionOrdersController < ApplicationController
  before_action :confirm_user

  def new
    @cart_items = CartItem.find_by_user_id(current_user.id)
                                  .order(id: "desc").includes(:product_item)
    if @cart_items.blank?
      redirect_to cart_items_path, notice: "没有商品，请先添加商品到购物车"
      return
    end
    @cart_items.each do |cart_item|
      if cart_item.amount > cart_item.product_item.amount
        redirect_to cart_items_path, notice:  "商品（#{cart_item.product_item.product.title}）数量不足，仅有 #{cart_item.product_item.amount}"
        return
      end
    end
  end

  def create
    cart_items = CartItem.find_by_user_id(current_user.id).includes(:product_item)
    if cart_items.blank?
      redirect_to cart_items_path
      return
    end

    address = current_user.addresses.find(params[:address_id])
    @transaction_order = TransactionOrder.create_order_from_cart_items!(current_user, address, cart_items)

    render template: "transaction_orders/pay"
  end

  def pay
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.update(is_payed: true)
    @transaction_order.transaction_items.each do |item|
      product_item = item.product_item
      amount = item.amount
      product = product_item.product
      record = Record.new(behaviour: Record::Behavior::Buy,
                          product_id: product.id,
                          user_id: session[:user_id],
                          amount: amount,
                          money: item.money)
      record.save!
    end
    redirect_to cart_items_path
  end

end
