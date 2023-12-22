class ChangeAmountDefaultInRecords < ActiveRecord::Migration[6.1]
  def change
    change_column_default :records, :amount, 1
  end
end
