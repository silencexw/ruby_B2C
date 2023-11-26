class CreateTransactionOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.decimal :total_money, precision: 10, scale: 2
      t.string :order_no
      t.timestamps
    end

    add_index :transaction_orders, [:order_no], unique: true
  end
end
