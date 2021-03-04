class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.references :user
      t.string :uid
      t.string :provider

      t.timestamps

      t.index %i[uid provider], unique: true
    end
  end
end
