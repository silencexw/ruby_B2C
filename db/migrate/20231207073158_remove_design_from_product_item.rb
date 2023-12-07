class RemoveDesignFromProductItem < ActiveRecord::Migration[6.1]
  def change
    remove_column :product_items, :design, :string

  end
end
