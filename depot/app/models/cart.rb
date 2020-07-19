# 购物车
class Cart < ApplicationRecord
  # 删除购物车，则会删除与此购物车关联的商品
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)

    # 添加的是购物车已有的商品，则数量 + 1
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
    end

    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

end
