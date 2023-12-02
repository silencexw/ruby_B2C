class AddSizeAndColor < ActiveRecord::Migration[6.1]
  def change
    add_column :cart_items, :size_id, :integer
    add_column :cart_items, :color_id, :integer
    add_column :transaction_items, :size_id, :integer
    add_column :transaction_items, :color_id, :integer
  end
end
