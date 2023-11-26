class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address_type
      t.string :contact_name, :cellphone, :address
      t.timestamps
    end
  end
end
