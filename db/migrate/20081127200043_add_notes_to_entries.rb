class AddNotesToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :notes, :text
  end

  def self.down
    remove_column :entries, :notes
  end
end
