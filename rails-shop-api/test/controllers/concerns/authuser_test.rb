require "test_helper"

class MockController
  include Authuser
  attr_accessor :request
end

class MockRequest
  attr_accessor :headers
  def initialize headers
    @headers = headers
  end
end

class AuthuserTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    # 构造： @authentication.request
    @authentication = MockController.new
    # 构造: @authentication.request.headers = {}
    @authentication.request = MockRequest.new({})
  end

  # 编写测试
  test "should get user from Authorization token" do
    @authentication.request.headers["Authorization"] = JsonWebToken.encode(user_id: @user.id)
    assert_not_nil @authentication.current_user
    assert_equal @user.id, @authentication.current_user.id
  end

  test "should not get user from empty Authorization token" do
    @authentication.request.headers["Authorization"] = nil
    assert_nil @authentication.current_user
  end
end
