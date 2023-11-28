class Dashboard::TransactionOrdersController < Dashboard::DashboardController
  def index
    @transaction_orders = current_user.transaction_orders.page(params[:page] || 1).per_page(params[:per_page] || 10)
                          .includes([:transaction_items, :address]).order(id: "desc")
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
end
