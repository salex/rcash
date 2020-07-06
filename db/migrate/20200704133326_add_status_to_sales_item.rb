class AddStatusToSalesItem < ActiveRecord::Migration[6.0]
  def change
    add_column :sales_items, :status, :string 
    # change_column :sales_items, :bottles_2,  'integer USING CAST(bottles_2 AS integer)'

  end
  def self.up
    change_column :sales_items, :bottles_2, :integer, using: 'bottles_2::integer'
  end

  # def up
  #   execute "ALTER TABLE sales_items ALTER bottles_2 DROP DEFAULT;"
  #   change_column :users, :gender, :integer, using: 'gender::integer', default: 0
  # end
end
