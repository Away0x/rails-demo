class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale, Authenticate

  def set_site
    Current.site = Site.first
  end

  def require_site
    unless Current.site
      redirect_to setup_path
    end
  end
end
