class CreateAccountClasses < ActiveRecord::Migration
  def self.up
    create_table :account_classes do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :account_classes
  end
end
