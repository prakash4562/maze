class MembersController < ApplicationController
  before_action :authenticate_user!

  def upload

  end

  def import
    User.import(params[:file])
    UserMailer.with(user: @user).welcome_email.deliver_later
    redirect_to members_path #, flash[:notice] =  "Posts has been imported successfully."
  end

  def index
    if current_user.roles.first.name == "admin"
      @users = User.order(created_at: :desc)
      respond_to do |format|
        format.html
        format.csv { send_data @users.to_csv }
        format.xlsx
      end
    else
      redirect_to posts_path
    end
  end

  def limited_report
    @users = User.all

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv_limited }
      format.xlsx
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
        UserMailer.with(user: @user).welcome_email.deliver_now
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
