class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :products, null: false, foreign_key: true
      t.references :users, null: false, foreign_key: true
      t.timestamps
    end
  end
end
