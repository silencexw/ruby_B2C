class Admin::ColorsController < Admin::AdminController
  before_action :get_product

  def index
    @colors = @product.colors
  end

  def create
    unless params[:colors].nil?
      params[:colors].each do |color|
        unless color.to_i == 0
          @product.colors << Color.new(color_id: color)
        end
      end
    end

    redirect_to admin_product_colors_path(product_id: @product)
  end

  def destroy
    @color = @product.colors.find(params[:id])
    if @color.destroy
      redirect_to admin_product_colors_path(product_id: @product), notice: "颜色删除成功"
    else
      redirect_to admin_product_colors_path(product_id: @product), notice: "颜色删除失败"
    end
  end


  private
  def get_product
    @product = Product.find params[:product_id]
  end
end
