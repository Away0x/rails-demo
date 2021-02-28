class AddPhoneToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :phone, :string

    remove_index :users, :email
    add_index :users, :email
    add_index :users, :phone

    # 由于用户支持 email 和手机登录，所以该字段可能为空
    change_column :users, :email, :string, null: true
  end
end
