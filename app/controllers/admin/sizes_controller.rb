class Admin::SizesController < Admin::AdminController
  before_action :get_product

  def index
    @sizes = @product.sizes
  end

  def create
    unless params[:sizes].nil?
      params[:sizes].each do |size|
        unless size.to_i == 0
          @product.sizes << Size.new(size_id: size)
        end
      end
    end

    redirect_to admin_product_sizes_path(product_id: @product)
  end

  def destroy
    @size = @product.sizes.find(params[:id])
    if @size.destroy
      redirect_to admin_product_sizes_path(product_id: @product), notice: "尺寸删除成功"
    else
      redirect_to admin_product_sizes_path(product_id: @product), notice: "尺寸删除失败"
    end
  end


  private
  def get_product
    @product = Product.find params[:product_id]
  end
end
