# frozen_string_literal: true

class Category < ApplicationRecord

  has_many :products, dependent: :destroy

  # Category 是个树级结构 (使用 ancestry gem) ancestry 需要 record 有 ancestry 字段和索引
  has_ancestry orphan_strategy: :destroy # orphan_strategy: :destroy (父删除，子也跟着删除)
  # c = Category.create title: 'c1'
  # c2 = c.children.create title: 'c2'
  #
  # c.children # 得到了 <Category title: c2 ...>
  # c2.parent  # 得到了 <Category title: c1 ...>
  #
  # Category.roots # 得到了 <Category title: c1 ...> 即得到所有一级分类

  before_validation :correct_ancestry
  validates :title, presence:  { message: '名称不能为空' }
  validates :title, uniqueness: { message: '名称不能重复' }

  # 二维数组形式返回分类结构
  def self.grouped_data
    self.roots.order('weight desc').inject([]) do |result, parent|
      row = []
      row << parent
      row << parent.children.order('weight desc')
      result << row
    end
  end

  private

    def correct_ancestry
      self.ancestry = nil if self.ancestry.blank? # ancestry 可为 NULL 但是不能存空字符串
    end

end
