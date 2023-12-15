module Admin::ProductsHelper
  def get_product_name(id)
    Product.find_by(id: id).title
  end
end
