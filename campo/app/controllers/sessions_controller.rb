class SessionsController < ApplicationController
  include AuthPassword
  layout 'session'

  before_action :require_auth_password_enabled, only: [:create]

  # 登录页面
  def new
    if params[:return_to]
      session[:return_to] = URI(params[:return_to]).path
    end
  end

  # 登录
  def create
    user = User.where('lower(username) = lower(:login) or lower(email) = lower(:login)', login: params[:login]).first

    if user&.authenticate(params[:password])
      sign_in user
      redirect_to session.delete(:return_to) || root_path
    else
      @sign_in_error = true
      render :update_form
    end
  end

  # 登出
  def destroy
    sign_out
    redirect_to root_path
  end

end
