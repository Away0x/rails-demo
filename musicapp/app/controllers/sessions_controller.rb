class SessionsController < ApplicationController
  layout 'plain'

  skip_before_action :require_login

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:error] = t('error.login')
      render 'create'
    end
  end

  def destroy
    return unless logged_in?

    session.delete(:user_id)
    redirect_to new_session_path
  end

end