class Product < ApplicationRecord
  belongs_to :category, optional: true

  has_many :records, dependent: :destroy

  has_many :favorites, dependent: :destroy

  has_many :product_colors, dependent: :destroy

  has_many :product_sizes, dependent: :destroy

  before_create :set_default_attr

  has_many :product_items, dependent: :destroy

  scope :onShelf, -> { where(status: 'on') }

  # 不为空的验证
  validates_presence_of :category, message: "分类不能为空"
  validates_presence_of :msrp, message: "零售价不能为空"
  validates_presence_of :title, message: "商品名不能为空"
  validates_presence_of :price, message: "定价不能为空"
  validates_presence_of :description, message: "商品描述不能为空"

  # 输入格式验证
  validates_inclusion_of :status, in: %w[on off], message: "商品状态必须为on | off"
  # validates_numericality_of :amount, only_integer: true, message: "库存必须为整数",
  #                           if: proc { |product| !product.amount.blank? }
  validates_numericality_of :msrp, message: "零售价必须为数字",
                            if: proc { |product| !product.msrp.blank? }
  validates_numericality_of :price, message: "定价必须为数字",
                            if: proc { |product| !product.price.blank? }

  def main_product_image
    if product_items.blank?
      "no_product.jpg"
      return
    end
    product_items.first&.image
  end

  def get_product_item(size_id, color_id)
    item = self.product_items.find_by(product_id: self.id, size_id: size_id, color_id: color_id)

    item
  end




  private

  def set_default_attr
    self.uuid = SecureRandom.uuid
    self.status = 'off'
  end
end
