class UsersController < ApplicationController

  before_action :authenticate_user!, :only => [:edit, :update]

  def new
    redirect_to links_url if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params) 

    if @user.save
      login_as(@user)
      redirect_to links_url, :notice => "Welcome to Geekwise News!"
    else
      render "new"
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to edit_user_url, :notice => "Settings saved"
    else
      render "edit"
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
