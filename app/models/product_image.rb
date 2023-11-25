class ProductImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image

  validate :image_content_type

  def image_content_type
    if image.attached? && !image.content_type.in?(%w(image/jpeg image/png image/gif))
      errors.add(:image, 'must be a JPEG, PNG, or GIF')
    end
  end

  def resized_image(size)
    return unless image.attached?

    image.variant(resize: size)
  end
end
