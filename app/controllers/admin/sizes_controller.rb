class Admin::SizesController < Admin::AdminController
  before_action :get_size, only: [:edit, :update, :destroy]

  def index
    @sizes = size.all.page(params[:page] || 1).per_page(params[:per_page] || 10)
                   .order(id: "desc")
  end

  def new
    @size = size.new
  end

  def create
    @size = size.new(params.require(:size).permit!)

    if @category.save
      redirect_to admin_sizes_path, notice: "颜色新建成功"
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
      redirect_to admin_sizes_path, notice: "颜色修改成功"
    else
      render action: :new
    end
  end

  def destroy
    if @size.destroy
      redirect_to admin_sizes_path, notice: "删除成功"
    else
      redirect_to :back, notice: "删除失败"
    end
  end

  private
  def get_size
    @size = size.find(params[:id])
  end
end
