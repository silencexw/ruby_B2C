class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :notify_current_user_change

  def confirm_user
    unless logged_in?
      flash[:error] = "请先登录"
      redirect_to new_session_path
    end
  end

  private

  def notify_current_user_change
    ActiveSupport::Notifications.instrument('current_user.changed') do |payload|
      payload[:user] = current_user
      puts 'write new current_user to payload of nofification'
    end
  end
end
