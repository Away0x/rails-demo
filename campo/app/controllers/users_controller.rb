class UsersController < ApplicationController
  include AuthPassword
  layout 'session'

  before_action :require_auth_password_enabled, only: [:create]

  # 注册
  def new
    if params[:return_to]
      session[:return_to] = URI(params[:return_to]).path
    end

    @user = User.new
  end

  # 注册
  def create
    @user = User.new user_params

    if @user.save
      sign_in @user
      redirect_to session.delete(:return_to) || root_path
    else
      render 'update_form'
    end
  end

  # 字段验证
  # constraints by routes
  # attribute: /name|username|email|password/
  def validate
    user = User.new(params[:attribute] => params[:value])
    user.valid?
    errors = user.errors[params[:attribute]]

    render json: {
      valid: errors.empty?,
      message: errors.first
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end
