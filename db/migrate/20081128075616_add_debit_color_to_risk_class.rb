class AddDebitColorToRiskClass < ActiveRecord::Migration
  def self.up
    add_column :risk_classes, :debit_color, :string
    rename_column :risk_classes, :color, :credit_color
  end

  def self.down
    rename_column :risk_classes, :credit_color, :color
    remove_column :risk_classes, :debit_color
  end
end
