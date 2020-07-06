class ChangeBottles2TypeStringIntegerSalesItem < ActiveRecord::Migration[6.0]
  def  up
    # change_column :sales_items, :bottles_2, integer: " USING bottles_2::integer"
    # change_column :sales_items, :bottles_2, 'integer USING CAST(bottles_2 AS integer)'

    change_column :sales_items, :bottles_2, "integer USING NULLIF(bottles_2, '')::int"
  end

  def down
    change_column :sales_items, :bottles_2, :string
  end

end
