class Dashboard::TransactionOrdersController < Dashboard::DashboardController
  def index
    @transaction_orders = current_user.transaction_orders.page(params[:page] || 1).per_page(params[:per_page] || 10)
                          .includes([:transaction_items, :address])
  end
end
