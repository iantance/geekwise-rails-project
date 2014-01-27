class UsersController < ApplicationController
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


private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
