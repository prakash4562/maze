class HomeController < ApplicationController
  def index
    if authenticate_user!
      flash[:notice] = "#{current_user.name} logged in successfully."
      redirect_to posts_path
    else
      flash[:notice] = "#{current_user.name} logged out successfully."
      redirect_to new_user_session_path
    end
  end
end
