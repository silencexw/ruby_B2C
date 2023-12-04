class CreateProductItems < ActiveRecord::Migration[6.1]
  def change
    create_table :product_items do |t|
      t.references  :product, null: false, foreign_key: true
      t.references :color, null: true, foreign_key: true
      t.references :size, null: true, foreign_key: true
      t.string :design, null: true
      t.decimal :msrp, precision: 10, scale: 2, default: 0
      t.integer :amount, default: 0
      t.string :image
      t.timestamps
    end
  end
end
