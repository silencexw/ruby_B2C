class CartItem < ApplicationRecord
  validates :product_item_id, presence: true
  validates :amount, presence: true

  belongs_to :product_item
  belongs_to :user

  scope :find_by_user_id, ->(user_id) { where(user_id: user_id) }

  def self.create_or_update!(options = {})
    cond = {
      user_id: options[:user_id],
      product_item_id: options[:product_item_id],
    }

    record = find_by(cond)
    if record
      record.update(amount: record.amount + options[:amount])
    else
      record = create!(options)
    end

    record
  end

  def get_product
    ele = Product.find_by(id: product_item.product_id)
    puts ele.id
    ele
  end

  def get_product_price
    product = get_product
    product.msrp
  end

end
