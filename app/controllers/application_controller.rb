class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def confirm_user
    unless logged_in?
      flash[:error] = "请先登录"
      redirect_to new_session_path
    end
  end
end
