class CreateTransactionItems < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_items do |t|
      t.references :transaction_order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :amount
      t.decimal :money, precision: 10, scale: 2
      t.timestamps
    end
  end
end
