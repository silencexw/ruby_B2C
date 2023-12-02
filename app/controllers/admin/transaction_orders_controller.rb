class Admin::TransactionOrdersController < Admin::AdminController
  def index
    case params[:order_status]
    when "待付款"
      @transaction_orders = TransactionOrder.all.where(is_payed: false).page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    when "待发货"
      @transaction_orders = TransactionOrder.all.where(is_payed: true, is_delivered: false).page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    else
      @transaction_orders = TransactionOrder.all.page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    end
  end

  def destroy
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.destroy
    redirect_to admin_transaction_orders_path
  end

  def delivery
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.update(is_delivered: true)
    redirect_to admin_transaction_orders_path
  end
end
