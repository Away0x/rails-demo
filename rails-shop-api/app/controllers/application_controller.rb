class ApplicationController < ActionController::API
  include Authuser
  include Paginable
end
