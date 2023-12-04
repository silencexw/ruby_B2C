class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.integer :behaviour, null: false
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :amount, default: 0
      t.decimal :money, precision: 10, scale: 2, default: 0
      t.timestamps
    end

    add_index :records, [:behaviour]
  end
end
