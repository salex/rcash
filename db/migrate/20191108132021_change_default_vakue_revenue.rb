class ChangeDefaultVakueRevenue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :revenues, :amount, from: 0.0, to: nil
    change_column_default :revenues, :quanity, from: 0.0, to: nil

  end
end
