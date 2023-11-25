class Admin::ProductImagesController < Admin::AdminController
  before_action :get_product

  def index
    @product_images = @product.product_images
  end

  def create
    params[:images].each do |image|
      @product.product_images << ProductImage.new(image: image)
    end

    redirect_to admin_product_product_images_path(product_id: @product)
  end

  def destroy
    @product_image = @product.product_images.find(params[:id])
    if @product_image.destroy
      redirect_to admin_product_product_images_path(product_id: @product), notice: "删除成功"
    else
      redirect_to admin_product_product_images_path(product_id: @product), notice: "删除失败"
    end
  end

  def update
    @product_image = @product.product_images.find(params[:id])
    @product_image.weight = params[:weight]
    if @product_image.save
      redirect_to admin_product_product_images_path(product_id: @product), notice: "修改成功"
    else
      redirect_to admin_product_product_images_path(product_id: @product), notice: "修改失败"
    end
  end

  private
  def get_product
    @product = Product.find params[:product_id]
  end
end
