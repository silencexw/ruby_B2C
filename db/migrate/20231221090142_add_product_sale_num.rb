class AddProductSaleNum < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :sale_num, :integer, default: 0
  end
end
