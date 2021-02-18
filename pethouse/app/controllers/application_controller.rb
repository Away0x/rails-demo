class ApplicationController < ActionController::Base

    def check_login
        @current_user ||= session[:account_id] && Account.find(session[:account_id])
    end

end
