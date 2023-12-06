class Dashboard::FavoritesController < Dashboard::DashboardController
  before_action :get_favorite, only: [:destroy]

  def index
    @favorites = Favorite.find_by_user_id(session[:user_id])
                         .order(id: "desc").includes(:product)
  end


  def destroy
    @favorite.destroy if @favorite

    redirect_to dashboard_favorites_path
  end

  private
  def get_favorite
    @favorite = Favorite.find_by_user_id(session[:user_id])
                        .where(id: params[:id]).first
  end
end
