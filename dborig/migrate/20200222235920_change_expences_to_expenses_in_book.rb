class ChangeExpencesToExpensesInBook < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :expences, :expenses
  end
end
