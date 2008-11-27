class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.boolean :liability
      t.integer :risk_class_id
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
