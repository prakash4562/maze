class MembersController < ApplicationController
  def index

    @users = User.order(created_at: :desc)

  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create

  end

  def ban
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    redirect_to members_path
  end


end
