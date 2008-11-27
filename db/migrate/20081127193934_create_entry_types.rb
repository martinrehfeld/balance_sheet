class CreateEntryTypes < ActiveRecord::Migration
  def self.up
    create_table :entry_types do |t|
      t.string :name
      t.boolean :cumulative

      t.timestamps
    end
  end

  def self.down
    drop_table :entry_types
  end
end
