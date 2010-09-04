class CreateCashflows < ActiveRecord::Migration
  def self.up
    create_table :cashflows do |t|
      t.integer :portfolio_id
      t.date :date
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :cashflows
  end
end
