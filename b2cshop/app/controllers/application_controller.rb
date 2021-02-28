# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_browser_uuid

  protected

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

    def fetch_home_data
      @categories = Category.grouped_data
    end

    def set_browser_uuid
      uuid = cookies[:user_uuid]

      unless uuid
        if logged_in?
          uuid = current_user.uuid
        else
          uuid = RandomCode.generate_token
        end
      end

      update_browser_uuid uuid
    end

    def update_browser_uuid(uuid)
      # cookies.permanent: 长期 cookies
      session[:user_uuid] = cookies.permanent[:user_uuid] = uuid
    end

end
