class Admin::AdminController < ActionController::Base

  layout 'admin/layouts/admin'

  before_action :confirm_admin

  def confirm_admin
    unless logged_in? and current_user.is_admin?
      flash[:notice] = "无管理员权限"
      redirect_to new_session_path
    end
  end

end