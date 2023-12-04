class TransactionItem < ApplicationRecord
  belongs_to :transaction_order
  belongs_to :product_item

  validates :transaction_order_id, presence: true
  validates :product_id, presence: true
end
