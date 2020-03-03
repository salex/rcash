class CreateDeposit < ActiveRecord::Migration[6.0]
  def change
    create_table :deposits do |t|
      t.date :date
      t.float :sales_revenue, default: 0.0
      t.float :other_revenue, default: 0.0
      t.float :cash_sales, default: 0.0
      t.float :credit_sales, default: 0.0
      t.float :tips_paid, default: 0.0
      t.float :sales_deposit, default: 0.0
      t.float :other_deposit, default: 0.0
      t.float :total_deposit, default: 0.0
      t.float :cash_out, default: 0.0
    end
  end
end
