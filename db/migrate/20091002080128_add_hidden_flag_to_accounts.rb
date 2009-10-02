class AddHiddenFlagToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :hidden, :boolean
  end

  def self.down
    remove_column :accounts, :hidden
  end
end
