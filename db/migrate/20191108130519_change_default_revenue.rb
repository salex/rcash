class ChangeDefaultRevenue < ActiveRecord::Migration[6.0]
  def change
    change_column_null :revenues, :quanity, true
    change_column_null :revenues, :amount, true
  end
end
