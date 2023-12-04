class ProductItem < ApplicationRecord
  has_one_attached :image

  belongs_to :product

  belongs_to :size, optional: true
  belongs_to :color, optional: true
end
