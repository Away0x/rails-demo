module SessionsHelper

  # 登入指定的用户 (浏览器关闭即退出)
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # 在持久会话中记住用户 (浏览器关闭也不会退出)
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    # permanent: 持久化 cookie 存储
    # signed: 加密 cookie 存储
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 返回当前登录的用户
  # Returns the user corresponding to the remember token cookie.
  # 1. 判断是否已登陆
  # 2. 判断是否有 remember_token
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 如果用户已登录，返回 true，否则返回 false
  def logged_in?
    !current_user.nil?
  end

  # 忘记持久会话
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 退出当前用户
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 如果指定用户是当前用户，返回 true
  def current_user?(user)
    user && user == current_user
  end

  # 重定向到存储的地址或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # 存储后面需要使用的地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
