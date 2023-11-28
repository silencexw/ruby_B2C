class AddOrderOtherColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_orders, :is_payed, :boolean, default: false
    add_column :transaction_orders, :is_delivered, :boolean, default: false
  end
  add_index :transaction_orders, [:is_payed]
  add_index :transaction_orders, [:is_delivered]
end
