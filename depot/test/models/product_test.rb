require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # 使用测试固件
  # 在各个测试用例方法运行之前，fixtures 指令会根据给定的模型名称，
  # 把对应的固件数据加载到对应的数据库表中
  # (每次 ProductTest 测试运行前，会清空 products 表，然后填充 fixtures/products.yml 数据到表中)
  fixtures :products # 对应 fixtures/products.yml

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
                          description: "yyy",
                          image_url: "zzz.jpg")

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
    
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "image url" do
    def new_product(image_url)
      Product.new(title: "My Book Title",
                  description: "yyy",
                  price: 1,
                  image_url: image_url)
    end

    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    # products(:ruby) 使用固件 fixtures products 中的 ruby 数据
    product = Product.new(title: products(:ruby).title,
      description: "yyy",
      price: 1,
      image_url: "fred.gif")
    
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title: products(:ruby).title,
      description: "yyy",
      price: 1,
      image_url: "fred.gif")

    assert product.invalid?
    assert_equal [I18n.translate('errors.message.taken')], product.errors[:title]
  end
end
