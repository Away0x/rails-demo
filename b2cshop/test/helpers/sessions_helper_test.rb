require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:one)
  end

  test "current_user returns right user when session is nil" do
    log_in(@user)

    assert_equal @user, current_user
    assert current_user?(@user)
    assert logged_in?
  end

  test "current_user return nil when user log_out" do
    log_in(@user)

    assert logged_in?
    log_out
    assert_not logged_in?
    assert_nil current_user
  end

  test "current_user returns nil when remember digest is wrong" do
    remember(@user)
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end
