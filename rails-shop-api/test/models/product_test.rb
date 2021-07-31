require "test_helper"

class ProductTest < ActiveSupport::TestCase

  setup do
    @p_one = products(:one)
  end

  # 使用全部合法的参数(合法的 title，合法的 price，合法的 published, 合法的 shop_id)创建商品，断言：通过验证
  test 'valid: product with all valid things' do
    product = Product.new(title: "title123", price: 1, published: 1, shop_id: @p_one.shop.id)
    assert product.valid?
  end

  # 使用非法的 title，合法的 price，合法的 published, 合法的 shop_id 创建商品，断言：未通过验证
  test 'invalid: product with invalid title' do
    product = Product.new(title: "", price: 1, published: 1, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end

  # 使用重复的 title 和 shop_id，合法的 price，合法的 published 创建商品，断言：未通过验证
  test 'invalid: product with taken title and shop_id' do
    product = Product.new(title: @p_one.title, price:1, published: 1, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end

  # 使用非法的 published，合法的 title，合法的 price ,合法的 shop_id 创建商品，断言：未通过验证
  test 'invalid: product with invalid published' do
    product = Product.new(title: 'first test', price: 1, published: 2, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end

  # 使用非法的 price，合法的 published，合法的 title ,合法的 shop_id 创建商品，断言：未通过验证
  test 'invalid: product with invalid price' do
    product = Product.new(title: 'first test', price: -100, published: 1, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end

end
