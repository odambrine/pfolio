class CreateHoldings < ActiveRecord::Migration
  def self.up
    create_table :holdings do |t|
      t.integer :user_id
      t.integer :portfolio_id
      t.boolean :admin, :default => true
      t.boolean :show_in_graph, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :holdings
  end
end
