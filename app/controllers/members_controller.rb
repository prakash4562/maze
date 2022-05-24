class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.roles.first.name == "admin"
      @users = User.order(created_at: :desc)
      respond_to do |format|
        format.html
        format.csv { send_data @users.to_csv }
        # format.xls { send_data @users.to_csv }
      end
    else
      redirect_to posts_path
    end
  end


  def edit
    if current_user.roles.first.name == "admin"
      @user = User.find(params[:id])
    else
      redirect_to posts_path
    end
  end

  def new
    if current_user.roles.first.name == "admin"
      @user = User.new
    else

      redirect_to posts_path
    end
  end

  def create
    if current_user.roles.first.name == "admin"
      @user = User.new(user_params)
      @user.add_role params[:roles]
      if @user.save!
        redirect_to posts_path
      else
        redirect_to new
      end
    else
      redirect_to posts_path
    end
  end

  def ban
    if current_user.roles.first.name == "admin"
      @user = User.find(params[:id])
      if @user.access_locked?
        @user.unlock_access!
      else
        @user.lock_access!
      end
      redirect_to members_path
    else
      redirect_to posts_path
    end
  end

  private

  def user_params
    params.permit(:name, :lname, :email, :number, :password, :password_confirmation)
  end
end
