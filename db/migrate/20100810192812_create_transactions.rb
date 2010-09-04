class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.date :date
      t.integer :portfolio_id
      t.integer :security_id
      t.string :operation
      t.decimal :quantity
      t.decimal :price
      t.decimal :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
