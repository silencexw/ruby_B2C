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

  def get_records
    # 时间限制
    get_record_by_time

    # render json: @records
    # 对应行为的record
    @records = @records.where(behaviour: params[:behaviour])
    # 用户
    unless params[:user_id].nil?
      @records = @records.where(user_id: params[:user_id])
    end
    # 产品
    unless params[:product_id].nil?
      @records = @records.where(product_id: params[:product_id])
    end
    # 种类
    unless params[:category_id].nil?
      @records = @records.joins(:product).where(products: { category_id: params[:category_id] })
    end

    render json: @records
  end

  private
  def get_record_by_time
    time_range = params[:time_range]
    time_range_val = params[:time_range_val].to_i
    case time_range
    when "year"
      start_time = time_range_val.years.ago
    when "month"
      start_time = time_range_val.months.ago
    when "week"
      start_time = time_range_val.weeks.ago
    when "day"
      start_time = time_range_val.days.ago
    else
      start_time = Time.now
    end

    @records = Record.where("created_at >= ?", start_time)
  end

  def get_records_params
    params.require(:profile).permit(:time_range, :time_range_val, :behaviour, :user_id, :product_id, 
      :category_id)
  end

end
