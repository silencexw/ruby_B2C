class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :title
      t.string :status, default: 'off'
      t.integer :amount, default: 0
      t.string :uuid
      t.decimal :msrp, precision: 10, scale: 2, default: 0
      t.decimal :price, precision: 10, scale: 2, default: 0
      t.text :description

      t.timestamps
    end

    add_index :products, [:status, :category_id]
    add_index :products, [:uuid], unique: true
    add_index :products, [:title]
  end
end
