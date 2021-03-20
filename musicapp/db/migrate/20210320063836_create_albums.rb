class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.string :image
      t.belongs_to :artist
      t.timestamps
      t.index :name
    end
  end
end
