class CreateProductColors < ActiveRecord::Migration[6.1]
  def change
    create_table :product_colors do |t|
      t.references :product, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true
      t.timestamps
    end

    add_index :product_items, [:product_id, :size_id, :color_id]
  end
end
