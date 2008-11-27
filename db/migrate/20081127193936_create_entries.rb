class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :account_id
      t.date :effective_date
      t.integer :entry_type_id
      t.float :value

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
