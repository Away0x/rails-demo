require "test_helper"

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = orders(:one)
    @user = users(:one)
  end

  # # 使用全部合法的参数(合法的 user_id，合法的 price_total )创建订单，断言：通过验证
  # test 'valid: order with all valid things' do
  #   order = Order.new(user_id:@user.id, price_total:1)
  #   assert order.valid?
  # end

  # # 使用非法的 price_total，合法的 user_id 创建订单，断言：未通过验证
  # test 'invalid: order with invalid price_total' do
  #   order = Order.new(user_id:@user.id, price_total:-1)
  #   assert_not order.valid?
  # end

end
