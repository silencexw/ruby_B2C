class Dashboard::TransactionOrdersController < Dashboard::DashboardController
  def index
    case params[:order_status]
    when "待付款"
      @transaction_orders = current_user.transaction_orders.where(is_payed: false).page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    when "待发货"
      @transaction_orders = current_user.transaction_orders.where(is_payed: true, is_delivered: false).page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    when "待收货"
      @transaction_orders = current_user.transaction_orders.where(is_payed: true, is_delivered: true, is_over: false).page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    when "已完成"
      @transaction_orders = current_user.transaction_orders.where(is_payed: true, is_delivered: true, is_over: true).page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    else
      @transaction_orders = current_user.transaction_orders.page(params[:page] || 1).per_page(params[:per_page] || 10)
                                        .includes([:transaction_items, :address]).order(id: "desc")
    end
  end

  def destroy
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.destroy
    redirect_to dashboard_transaction_orders_path
  end

  def pay
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.update(is_payed: true)
    redirect_to dashboard_transaction_orders_path
  end

  def over
    @transaction_order = TransactionOrder.find(params[:id])
    @transaction_order.update(is_over: true)
    redirect_to dashboard_transaction_orders_path
  end
end
