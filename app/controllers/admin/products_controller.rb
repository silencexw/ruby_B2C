require 'csv'

class Admin::ProductsController < Admin::AdminController
  before_action :get_product, only: [:edit, :update, :destroy, :onShelf]
  before_action :get_sizes, only: [:edit, :update, :destroy, :onShelf]
  before_action :get_colors, only: [:edit, :update, :destroy, :onShelf]

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
    # puts @product
    # puts params
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

  require 'csv'

  def import_products_from_csv
    file_path = params[:file_path].tempfile.path

    begin
      csv = CSV.open(file_path,  headers: true, encoding: 'utf-8')

      csv.each do |row|
        product_attributes = row.to_hash.symbolize_keys
        category = Category.find_by(title: product_attributes[:category_name])
        puts product_attributes
        puts product_attributes[:category_name]
        puts category


        if category.nil?
          flash[:error] = "文件格式不正确，无法解析"
          redirect_to admin_products_path
        end

        product_attributes[:category_id] = category.id
        product_attributes.delete(:category_name)

        Product.create!(product_attributes)
      end

      redirect_to admin_products_path, notice: "导入成功"
    rescue CSV::MalformedCSVError => e
      flash[:error] = "文件格式不正确，无法解析"
      redirect_to admin_products_path
    end
  end

  def onShelf
    if @product.product_items.blank?
      flash[:error] = "无具体产品，上架失败"
      redirect_to admin_products_path
      return
    end
    @product.update!(:status => 'on')
    @product.save
    redirect_to admin_products_path, notice: "上架成功"
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

  def get_sizes
    @sizes = []

    @product.product_sizes.each do |product_size|
      @sizes << Size.find(product_size.size_id)
    end
  end

  def get_colors
    @colors = []

    @product.product_colors.each do |product_color|
      @colors << Color.find(product_color.color_id)
    end
  end
end
