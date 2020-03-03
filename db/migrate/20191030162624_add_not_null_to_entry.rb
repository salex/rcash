class AddNotNullToEntry < ActiveRecord::Migration[6.0]
  def change
    change_column :entries, :book_id, :integer, :null => false
  end
end
