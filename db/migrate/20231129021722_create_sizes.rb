class CreateSizes < ActiveRecord::Migration[6.1]
  def change
    create_table :sizes do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :size_id
      t.timestamps
    end
  end
end
