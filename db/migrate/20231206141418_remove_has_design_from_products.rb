class RemoveHasDesignFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :has_design, :boolean
  end
end
