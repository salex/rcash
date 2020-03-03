class AddDefaultBookToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :default_book, :integer
  end
end
