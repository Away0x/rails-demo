class Placement < ApplicationRecord
  # placement 作为中间表关联多对多模型对象 product <> order

  belongs_to :order
  belongs_to :product, inverse_of: :placements

  after_create :decrement_product_quantity!

  private
    def decrement_product_quantity!
      product.decrement!(:quantity, quantity)
    end

end
