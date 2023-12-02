class Product < ApplicationRecord
  belongs_to :category, optional: true

  has_many :product_images, -> { order(weight: 'desc') }, dependent: :destroy

  has_many :colors, -> { order(color_id: 'asc') }, dependent: :destroy

  has_many :sizes, -> { order(size_id: 'asc') }, dependent: :destroy

  before_create :set_default_attr

  has_one :main_product_image, -> { order(weight: 'desc') },
          class_name: :ProductImage

  scope :onShelf, -> { where(status: 'on') }



  # 不为空的验证
  validates_presence_of :category, message: "分类不能为空"
  validates_presence_of :amount, message: "库存不能为空"
  validates_presence_of :msrp, message: "零售价不能为空"
  validates_presence_of :title,message: "商品名不能为空"
  validates_presence_of :price, message: "定价不能为空"
  validates_presence_of :description, message: "商品描述不能为空"


  # 输入格式验证
  validates_inclusion_of :status, in: %w[on off], message: "商品状态必须为on | off"
  validates_numericality_of :amount, only_integer: true, message: "库存必须为整数",
            if: proc { |product| !product.amount.blank? }
  validates_numericality_of :msrp, message: "零售价必须为数字",
            if: proc { |product| !product.msrp.blank? }
  validates_numericality_of :price, message: "定价必须为数字",
            if: proc { |product| !product.price.blank? }

  private
  def set_default_attr
    self.uuid = SecureRandom.uuid
  end
end
