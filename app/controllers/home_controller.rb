class HomeController < ApplicationController
  def index
    if authenticate_user!
      redirect_to posts_path
    else
      redirect_to root_path
    end
  end
end
