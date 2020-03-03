class AddBookIdToEntry < ActiveRecord::Migration[6.0]
  def change
    add_reference :entries, :book, foreign_key: true
  end
end
