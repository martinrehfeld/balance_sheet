class CreateRiskClasses < ActiveRecord::Migration
  def self.up
    create_table :risk_classes do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :risk_classes
  end
end
