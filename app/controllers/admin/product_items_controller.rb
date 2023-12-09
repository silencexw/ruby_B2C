class Admin::ProductItemsController < Admin::AdminController
  before_action :get_product
  before_action :get_colors, :get_sizes
  before_action :get_item ,only: [:update]

  def new
    @product_item = ProductItem.new
  end

  def create
    puts params
    puts params[:size_id]

    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @product_item = ProductItem.new(params.require(:product_item).permit!)
    if @product_item.save
      @product.product_items << @product_item
      flash[:success] = "商品创建成功"
      redirect_to admin_product_product_items_path(product_id: @product)
    else
      flash[:error] = "商品创建失败"
      render :new
    end
  end

  def index
    @product_items = @product.product_items.all.page(params[:page] || 1)
                             .per_page(params[:per_page] || 10).order(id: "desc")
  end

  def edit
    @product_item = @product.product_items.find(params[:id])
    render action: :new
  end

  def update

    puts @product_item

    @product_item.attributes = params.require(:product_item).permit!
    if @product_item.save
      redirect_to admin_product_product_items_path(product_id: @product), notice: "修改成功"
    else
      render action: :new
    end
  end

  def destroy
    @product_item = @product.product_items.find(params[:id])
    if @product_item.destroy
      redirect_to admin_product_product_items_path(product_id: @product), notice: "删除成功"
    else
      redirect_to admin_product_product_items_path(product_id: @product), notice: "删除失败"
    end
  end

  private
  def get_product
    @product = Product.find params[:product_id]
  end

  def get_colors
    get_product
    @colors = @product.product_colors
  end

  def get_sizes
    get_product
    @sizes = @product.product_sizes
  end

  def get_item
    @product_item = @product.product_items.find(params[:id])
  end
end
