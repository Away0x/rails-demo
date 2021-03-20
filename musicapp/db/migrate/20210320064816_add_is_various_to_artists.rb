class AddIsVariousToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column(:artists, :is_various, :boolean, default: false)
  end
end
