class AddOrderIsOverColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_orders, :is_over, :boolean, default: false
  end
  add_index :transaction_orders, [:is_over]
end
