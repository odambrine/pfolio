class CreateSecurities < ActiveRecord::Migration
  def self.up
    create_table :securities do |t|
      t.string :name
      t.string :ticker
      t.string :security_type

      t.timestamps
    end
  end

  def self.down
    drop_table :securities
  end
end
