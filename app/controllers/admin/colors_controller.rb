class Admin::ColorsController < Admin::AdminController
  before_action :get_color, only: [:edit, :update, :destroy]

  def index
    @colors = Color.all.page(params[:page] || 1).per_page(params[:per_page] || 10)
                             .order(id: "desc")
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(params.require(:color).permit!)

    if @category.save
      redirect_to admin_colors_path, notice: "颜色新建成功"
    else
      render action: :new
    end
  end

  def edit
    render action: :new
  end

  def update
    @color.attributes = params.require(:color).permit!

    if @color.save
      redirect_to admin_colors_path, notice: "颜色修改成功"
    else
      render action: :new
    end
  end

  def destroy
    if @color.destroy
      redirect_to admin_colors_path, notice: "删除成功"
    else
      redirect_to :back, notice: "删除失败"
    end
  end

  private
  def get_color
    @color = Color.find(params[:id])
  end
end
