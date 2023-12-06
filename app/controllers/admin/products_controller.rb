class Admin::ProductsController < Admin::AdminController
  before_action :get_product, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
    @root_categories = Category.roots
  end

  def index
    @products = Product.page(params[:page] || 1).per_page(params[:per_page] || 10)
                       .order(id: "desc")
  end

  def create
    @product = Product.new(product_params)
    puts @product
    puts params
    @root_categories = Category.roots

    if @product.save
      redirect_to admin_products_path, notice: "创建成功"
    else
      render action: :new
    end
  end

  def edit
    @root_categories = Category.roots
    render action: :new
  end

  def update
    @product.attributes = params.require(:product).permit!
    @root_categories = Category.roots
    if @product.save
      redirect_to admin_products_path, notice: "修改成功"
    else
      render action: :new
    end
  end

  def destroy
    if @product.destroy
      redirect_to admin_products_path, notice: "删除成功"
    else
      redirect_to :back, notice: "删除失败"
    end
  end

  private
  def get_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :category_id, :msrp, :price, :has_size, :has_color, :has_design, :description)
  end
end
