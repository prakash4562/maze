class HomeController < ApplicationController
  def index
    if authenticate_user!
      flash[:notice] = "#{current_user.name} logged in successfully."
      redirect_to posts_path
    else
      flash[:notice] = "#{current_user.name} logged out successfully."
      redirect_to root_path
    end
  end
end
