class UiController < ApplicationController
  layout 'ui'

  def page
    page = params[:page] || 'index'
    render page
  end
end
