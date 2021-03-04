class Auth::EmailController < ApplicationController
  def show
  end

  def create
    UserMailer.auth_email(params[:email]).deliver_later
  end
end
