# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  # 确保用户已登录
  def guard_logged
    unless logged_in?
      store_location
      flash[:warning] = '请先登录'
      redirect_to login_url
    end
  end

  # 确保用户未登录
  def guard_not_logged
    if logged_in?
      flash[:warning] = '您已经登录了'
      redirect_to root_path
    end
  end
end
