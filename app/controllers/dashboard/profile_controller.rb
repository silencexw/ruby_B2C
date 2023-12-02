class Dashboard::ProfileController < Dashboard::DashboardController
  def user_message
  end

  def update_message
    unless current_user.update(username: params[:username])
      @errors = current_user.errors.full_messages
      render action: :user_message
      return
    end

    if current_user.valid_password?(params[:old_password])
      current_user.password_confirmation = params[:password_confirmation]

      puts current_user.password_confirmation

      if current_user.change_password(params[:user_password])
        flash[:notice] = "个人信息修改成功"
        redirect_to dashboard_user_message_path
      else
        # 将验证失败的错误信息传递给视图
        @errors = current_user.errors.full_messages
        render action: :user_message
      end
    else
      current_user.errors.add :old_password, "旧密码不正确"
      render action: :user_message
    end
  end
end
