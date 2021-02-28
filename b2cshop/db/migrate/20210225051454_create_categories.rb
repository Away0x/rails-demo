class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :weight, default: 0, comment: '分类权重'
      t.integer :products_counter, default: 0, comment: '产品数量'
      t.string :ancestry, comment: '树结构的子关联字段'

      t.timestamps
    end

    add_index :categories, [:title]
    add_index :categories, [:ancestry]
  end
end
