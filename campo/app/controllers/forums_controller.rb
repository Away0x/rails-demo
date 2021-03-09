class ForumsController < ApplicationController
  def index
    @forums = Forum.order(topics_count: :desc)
  end

  def show
    @forums = Forum.find_by!(slug: params[:id])
  end

  # 字段验证
  # constraints by routes
  # attribute: /name|slug/
  def validate
    user = Forum.new(params[:attribute] => params[:value])
    user.valid?
    errors = user.errors[params[:attribute]]
    render json: {
      valid: errors.empty?,
      message: errors.first
    }
  end
end
