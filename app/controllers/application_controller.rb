class ApplicationController < ActionController::Base
  def confirm_user
    unless logged_in?
      redirect_to new_session_path, '请先登录'
    end
  end
end
