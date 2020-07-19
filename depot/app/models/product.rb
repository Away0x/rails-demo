class Product < ApplicationRecord
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  # title 唯一
  validates :title, uniqueness: true
  # 验证 image url 是否有效
  # allow_blank 防止 url 为空时产生多条错误信息
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

  private

  # 确保没有 line_item 在引用该 product
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort # 抛出 abort，则记录不会被删除
    end
  end

end
