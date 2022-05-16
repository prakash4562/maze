class MembersController < ApplicationController
  def index

    @users = User.order(created_at: :desc)

  end

  def edit
    @user = User.find(params[:id])
  end

  # def new
  #   @user = User.new
  # end

  # def create
  #   @user = User.new(user_params)
  #   @user.add_role params[:id]
  #   if @user.save!
  #     redirect_to posts_path
  #   else
  #     redirect_to new
  #   end
  # end

  def ban
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    redirect_to members_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :lname, :email, :number, :password, :password_confirmation)
  end
end
