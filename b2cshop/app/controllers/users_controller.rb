class UsersController < ApplicationController
  before_action :guard_not_logged, only: [:new, :create]

  def new
    @is_using_email = '1'
    @user = User.new
  end

  def create
    @is_using_email = user_params[:email].blank? ? '0' : '1'

    @user = User.new(user_params)
    @user.uuid = session[:user_uuid]

    if @user.save
      flash[:notice] = '注册成功，请登录'
      redirect_to login_path
    else
      render action: :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :phone, :password, :password_confirmation)
    end
end
