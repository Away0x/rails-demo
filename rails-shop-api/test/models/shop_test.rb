require "test_helper"

class ShopTest < ActiveSupport::TestCase

  # 使用全部合法的参数(合法的 name，合法的 user_id，合法的 products_count，合法的 orders_count)创建商铺，断言：通过验证
  test 'valid: shop with all valid things' do
    shop = Shop.new(name: 'shoptest01', products_count:0, orders_count:1)
    shop.user = users(:four)
    assert shop.valid?
  end

  # 使用重复的 name，合法的 user_id，合法的 products_count，合法的 orders_count 创建商铺，断言：未通过验证
  test 'invalid: shop with taken name' do
    shop = Shop.new(name: shops(:one).name, products_count:0, orders_count:1)
    shop.user = users(:five)
    assert_not shop.valid?
  end

  # 使用非法的 user_id，合法的 name，合法的 products_count，合法的 orders_count 创建商铺，断言：未通过验证
  test 'invalid: shop with invalid user_id' do
    shop = Shop.new(name: 'shoptest02', products_count:0, orders_count:1)
    shop.user = users(:one)
    assert_not shop.valid?
  end

  # 使用重复的 user_id，合法的 name，合法的 products_count，合法的 orders_count 创建商铺，断言：未通过验证
  test 'invalid: shop with taken user_id' do
    shop = Shop.new(name: 'shoptest03', products_count:0, orders_count:1)
    shop.user = shops(:one).user
    assert_not shop.valid?
  end

  # 使用非法的 orders_count，合法的 name，合法的 user_id，合法的 products_count 创建商铺，断言：未通过验证
  test 'invalid: shop with invalid products_count' do
    shop = Shop.new(name: 'shoptest04', products_count:0, orders_count:1.55)
    shop.user = users(:six)
    assert_not shop.valid?
  end

end
