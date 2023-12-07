class Admin::SizesController < Admin::AdminController
  before_action :get_product
  before_action :get_size, only: [:edit, :update, :destroy]

  def index
    @sizes = Size.all.page(params[:page] || 1).per_page(params[:per_page] || 10)
                 .order(id: "desc")
  end

  def new
    @size = Size.new
  end

  def select

    puts "眉山的sizes"
    puts params[:sizes]

    unless params[:sizes].nil?

      selected_sizes = params[:sizes].reject { |size| size.to_i.zero? }


      puts "删完了的sizes"
      puts selected_sizes

      selected_sizes.each do |size|
        @product.product_sizes << ProductSize.new(product_id: params[:product_id], size_id: size)
      end
    end

    redirect_to admin_product_sizes_path(product_id: @product)
  end

  def create
    @size = Size.new(params.require(:size).permit!)

    if @size.save
      redirect_to admin_product_sizes_path(product_id: @product), notice: "颜色新建成功"
    else
      render action: :new
    end
  end

  def edit
    render action: :new
  end

  def update
    @size.attributes = params.require(:size).permit!

    if @size.save
      redirect_to admin_product_sizes_path, notice: "颜色修改成功"
    else
      render action: :new
    end
  end

  def destroy
    if @size.destroy
      redirect_to admin_product_sizes_path, notice: "删除成功"
    else
      redirect_to :back, notice: "删除失败"
    end
  end

  private

  def get_size
    @size = Size.find(params[:id])
  end

  def get_product
    @product = Product.find(params[:product_id])
  end
end
