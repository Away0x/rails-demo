class AddSearchDataToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :search_data, :tsvector
    add_index :posts, :search_data, using: :gin
  end
end
