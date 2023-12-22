class Admin::UsersController < Admin::AdminController
  def index
    @users = User.where(is_admin: false).page(params[:page] || 1).per_page(params[:per_page] || 10)
                 .order(id: "desc")
  end

  def set_admin
    user = User.find(params[:user_id])
    user.update(is_admin: true)
    user.save!
    redirect_to admin_users_path, notice: "设置管理员成功"
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: "用户注销成功"
    else
      redirect_to :back, notice: "删除失败"
    end
  end

end
