class CreateColors < ActiveRecord::Migration[6.1]
  def change
    create_table :colors do |t|
      t.string :name
      t.string :hex_code
      t.integer :weight, default: 0
      t.timestamps
    end
  end
end
