class AddAccountClassIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :account_class_id, :integer
  end

  def self.down
    remove_column :accounts, :account_class_id
  end
end
