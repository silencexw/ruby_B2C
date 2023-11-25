class CreateProductImages < ActiveRecord::Migration[6.1]
  def change
    create_table :product_images do |t|
      t.belongs_to :product
      t.integer :weight, default: 0
      t.timestamps
    end

    add_column :product_images, :image, :string

    add_index :product_images, [:product_id, :weight]
  end
end
