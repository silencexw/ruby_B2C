class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :password, :password_confirmation))

    if @user.save
      redirect_to new_session_path, notice: "注册成功"
    else
      render :new
    end
  end

  def destroy
  end
end
