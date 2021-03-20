class CreateArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :image
      t.timestamps
      t.index :name, unique: true
    end
  end
end
