# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :guard_not_logged, only: [:new, :create]
  before_action :guard_logged, only: [:destroy]

  def new
  end

  def create
    session_params = params[:session]
    user = User.find_by(email: session_params[:email].downcase)

    if user&.authenticate(session_params[:password])
      log_in(user, session_params[:remember_me] == '1')
      flash[:notice] = '登录成功'
      return redirect_to root_path
    end

    flash[:warning] = '邮箱或者密码不正确'
    redirect_to login_form_path
  end

  def destroy
    log_out
    flash[:notice] = '退出成功'
    redirect_to root_path
  end
end
