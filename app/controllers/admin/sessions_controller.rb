class Admin::SessionsController < Admin::AdminController
  def new
    redirect_to root_path
  end
end
