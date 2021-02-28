class AddUuidToUsers < ActiveRecord::Migration[6.1]
  def change
    # 用户唯一标识 (会存储在 cookies 中)
    add_column :users, :uuid, :string
    add_index :users, :uuid, unique: true

    # 为老数据添加 uuid
    User.find_each do |user|
      user.uuid = RandomCode.generate_token
      user.save
    end
  end
end
