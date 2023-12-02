class TransactionOrder < ApplicationRecord
  has_many :transaction_items,  dependent: :destroy
  belongs_to :user
  belongs_to :address, optional: true

  validates :user_id, presence: true
  validates :total_money, presence: true
  validates :address_id, presence: true

  before_create :set_order_no

  def self.create_order_from_cart_items! user, address, *cart_items
    cart_items.flatten!
    address_attrs = address.attributes.except!("id", "created_at", "updated_at")

    transaction do
      order_address = user.addresses.create!(address_attrs.merge(
        "address_type" => 'order'
      ))

      order = user.transaction_orders.create!(
        address: order_address,
        total_money: 0
      )

      total_money = 0

      cart_items.each do |cart_item|
          order.transaction_items.create!(
          product: cart_item.product,
          amount: cart_item.amount,
          money: cart_item.amount * cart_item.product.price,
          size_id: cart_item.size_id,
          color_id: cart_item.color_id
        )

        cart_item.product.update(amount: cart_item.product.amount - cart_item.amount)
        total_money = total_money + cart_item.amount * cart_item.product.price
      end

      order.update!(total_money: total_money)

      cart_items.each(&:destroy!)

      order
    end
  end

  private
  def set_order_no
    self.order_no = SecureRandom.uuid
  end

end
