class FavoritesController < ApplicationController
  before_action :get_favorite, only: [:update, :destroy]

  def index
    @favorites = Favorite.find_by_user_id(session[:user_id])
                          .order(id: "desc").includes(:product)
  end

  def create
    if logged_in?
      @favorite = Favorite.new(user_id: session[:user_id], product_id: params[:product_id])
      if @favorite.save
        @product = Product.find(params[:product_id])
        redirect_to product_path(@product), notice: "收藏成功"
      end
    else
      flash[:error] = "请先登录"
      redirect_to new_session_path
    end
  end

  def destroy
    @favorite.destroy if @favorite

    redirect_to product_path(product_id: @favorite.product_id)
  end

  private
  def get_favorite
    @favorite = Favorite.find_by_user_id(session[:user_id])
                         .where(id: params[:id]).first
  end

end
