class TransactionItem < ApplicationRecord
  belongs_to :transaction_order
  belongs_to :product_item

  validates :transaction_order_id, presence: true
  validates :product_item_id, presence: true

  def get_product
    ele = Product.find_by(id: product_item.product_id)
    puts ele.id
    ele
  end
end
