require "test_helper"

class UserTest < ActiveSupport::TestCase

  # 使用全部合法的参数(合法的 email，合法的 password_digest，合法的 role)创建用户，断言：通过验证
  test 'valid: user with all valid things' do
    user = User.new(email: 'user@demo.com', password_digest: '123456', role: 1)
    assert user.valid?
  end

  # 使用非法的 email，合法的 password_digest，合法的 role 创建用户，断言：未通过验证
  test 'invalid: user with invalid email' do
    user = User.new(email: 'test', password_digest: '123456', role: 1)
    assert_not user.valid?
  end

  # 使用重复的 email，合法的 password_digest，合法的 role 创建用户，断言：未通过验证
  test 'invalid: user with taken email' do
    user = User.new(email: users(:one).email, password_digest: '123456', role: 1)
    assert_not user.valid?
  end

  # 使用非法的 password_digest，合法的 email，合法的 role 创建用户，断言：未通过验证
  test 'invalid: user with invalid password_digest' do
    user = User.new(email: 'test1@test.cn', password_digest: '', role: 1)
    assert_not user.valid?
  end

  # 使用非法的 role，合法的 email，合法的 password_digest 创建用户，断言：未通过验证
  test 'invalid: user with invalid role' do
    user = User.new(email: 'test2@test.cn', password_digest: '123456', role: 5)
    assert_not user.valid?
  end

  # 使用合法的 password，合法的 email，合法的 role 创建用户，断言：通过验证
  test 'valid: user with valid password' do
    user = User.new(email: 'test3@test.cn', password: '123456', role: 1)
    assert user.valid?
  end

  # 使用非法的 password，合法的 email，合法的 role 创建用户，断言：未通过验证
  test 'invalid: user with invalid password' do
    user = User.new(email: 'test4@test.cn', password: '', role: 1)
    assert_not user.valid?
  end

end
