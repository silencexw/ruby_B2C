class SessionsController < ApplicationController
  def new
  end

  def create
    if (user = login(params[:email], params[:password]))
      redirect_to root_path, notice: "登录成功"
    elsif User.username_confirm(params[:email], params[:password])
      user = User.find_by(username: params[:email])
      auto_login(user)
      redirect_to root_path, notice: "登录成功"
    else
      redirect_to new_session_path, notice: "邮箱或密码不正确"
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "退出成功"
  end
end
