class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites do |t|
      t.string :title
      t.string :description
      t.string :logo
      t.string :icon

      t.timestamps
    end
  end
end
