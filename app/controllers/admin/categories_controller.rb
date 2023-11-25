class Admin::CategoriesController < Admin::AdminController

  before_action :get_root_categories, only: [:new, :create, :edit, :update]
  before_action :get_category, only: [:edit, :update, :destroy]

  def index
    if params[:id].blank?
      @categories = Category.roots
    else
      @category = Category.find(params[:id])
      @categories = @category.children
    end

    @categories = @categories.page(params[:page] || 1).per_page(params[:per_page] || 10)
                             .order(id: "desc")
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit!)

    if @category.save
      redirect_to admin_categories_path, notice: "保存成功"
    else
      render action: :new
    end
  end

  def edit
    render action: :new
  end

  def update
    @category.attributes = params.require(:category).permit!

    if @category.save
      redirect_to admin_categories_path, notice: "修改成功"
    else
      render action: :new
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_path, notice: "删除成功"
    else
      redirect_to :back, notice: "删除失败"
    end
  end

  private
  def get_root_categories
    @root_categories = Category.roots.order(id: "desc")
  end

  def get_category
    @category = Category.find(params[:id])
  end

end
