class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :category_id, comment: '外键指向 categories 表' # 数据库层面并没有建立外键约束
      t.string :title
      t.string :status, default: 'off', comment: 'off 下架, on 上架'
      t.integer :amount, default: 0, comment: '库存数'
      t.string :uuid, comment: '商品序列号'
      t.decimal :msrp, precision: 10, scale: 2, comment: '市场建议零售价' # precision: 长度, scale: 小数点后位数
      t.decimal :price, precision: 10, scale: 2, comment: '销售价'
      t.text :description, comment: '商品描述'

      t.timestamps
    end

    add_index :products, [:status, :category_id] # 联合索引
    add_index :products, [:category_id]
    add_index :products, [:uuid], unique: true
    add_index :products, [:title]
  end
end
