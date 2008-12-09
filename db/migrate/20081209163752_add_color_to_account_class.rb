class AddColorToAccountClass < ActiveRecord::Migration
  def self.up
    add_column :account_classes, :color, :string
  end

  def self.down
    remove_column :account_classes, :color
  end
end
