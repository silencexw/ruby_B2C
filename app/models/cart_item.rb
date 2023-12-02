class CartItem < ApplicationRecord
  validates :product_id, presence: true
  validates :amount, presence: true

  belongs_to :product
  belongs_to :user

  scope :find_by_user_id, ->(user_id) { where(user_id: user_id) }

  def self.create_or_update!(options = {})
    cond = {
      user_id: options[:user_id],
      product_id: options[:product_id],
      size_id: options[:size_id],
      color_id: options[:color_id]
    }

    record = find_by(cond)
    if record
      record.update(amount: record.amount + options[:amount])
    else
      record = create!(options)
    end

    record
  end
end
