class Favorite < ApplicationRecord
  belongs_to :user

  belongs_to :product


  def main_favorite_image
    if product.product_items.blank?
      "no_product.jpg"
      return
    end
    product.product_items.first&.image
  end

end
