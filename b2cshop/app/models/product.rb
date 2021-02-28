class Product < ApplicationRecord
  # 商品是在二级分类上的，所以其 category_id 是二级分类 id

  module Status
    On = 'on'
    Off = 'off'
  end

  belongs_to :category

  before_create :set_default_attrs
  # 上架商品
  scope :on_shelf, -> { where(status: Status::On) }

  validates :category_id, presence: { message: '分类不能为空' }
  validates :title, presence: { message: '名称不能为空' }
  validates :status, inclusion: { in: [Status::On, Status::Off], message: '商品状态必须为 on | off' }

  validates :amount, numericality: { only_integer: true, message: '库存必须为整数' }
  validates :amount, presence: { message: '库存不能为空' }, if: proc { |product| !product.amount.blank? }

  validates :msrp, presence: { message: 'MSRP 不能为空' }
  validates :msrp, numericality: { message: 'MSRP 必须为数字' }, if: proc { |product| !product.msrp.blank? }

  validates :price, presence: { message: '价格不能为空' }
  validates :price, numericality: { message: '价格必须为数字' }, if: proc { |product| !product.price.blank? }

  validates :description, presence: { message: '描述不能为空' }

  private

    def set_default_attrs
      # 设置商品唯一序列号
      self.uuid = RandomCode.generate_product_uuid
    end

end
