class CreateColors < ActiveRecord::Migration[6.1]
  def change
    create_table :colors do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :color_id
      t.timestamps
    end
  end
end
