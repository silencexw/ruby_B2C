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
        notify_current_user_change
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

  def save_current_log
    puts 'try to save current log'
    MyLogSubscriber.save_log
    head :ok
  end

  def export_log
    MyLogSubscriber.export_log
    head :ok
  end

  def select_log
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

    action = params[:log_action].to_s == '' ? nil : params[:log_action]
    user_id = params[:user_id].to_s == '' ? nil : params[:user_id].to_s
    object = params[:log_object].to_s == '' ? nil : params[:log_object].to_s
    path = params[:log_path].to_s == '' ? nil : params[:log_path].to_s
    export = params[:export].to_i == 0 ? false : true
=begin
    puts 'parameters'
    puts action
    puts user_id == nil
    puts object == nil
    puts path == nil
    puts export
    puts start_time
=end
    custom_users = []
    User.all.each do |user|
      if (!user.is_admin)
        custom_users << user.id
      end
    end
    ret_val = MyLogSubscriber.select_log(user_id, action, start_time, object, path, export, 
    custom_users)
    # render plain: ret_val.to_s
    render json: ret_val
  end

  def get_records
    # save_current_log
    # 时间限制
    get_record_by_time

    # render json: @records
    # 对应行为的record
    @records = @records.where(behaviour: params[:behaviour])
    # 用户
    unless params[:user_name].nil?
      @user = User.find_by(username: params[:user_name])
      if (@user == nil) 
        @records = @records
      else
        @records = @records.where(user_id: @user.id)
      end
      # @records = @records.where(user_id: params[:user_id])
    end
    # 产品
    unless params[:product_id].nil?
      @records = @records.where(product_id: params[:product_id])
    end
    # 种类
    unless params[:category_id].nil?
      # @records = @records.joins(:product).where(products: { category_id: params[:category_id].to_i })
      ans = []
      @records.each do |record|
        product = Product.find(record.product_id)  
        if product.category_id == params[:category_id].to_i
          ans << record
        elsif Category.find(product.category_id).ancestry.to_i == params[:category_id].to_i
          ans << record
        end
      end
      @records = ans
    end

    render json: @records
  end

  def get_stat
    render 'index'
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
    params.require(:profile).permit(:time_range, :time_range_val, :behaviour, :user_name, :product_id, 
      :category_id, :log_path, :user_id, :log_action, :log_object, :export)
  end

end
