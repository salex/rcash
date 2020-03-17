class AddLockToEntry < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :lock_version, :integer
    add_column :splits, :lock_version, :integer

  end
end
