class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.date :date
      t.integer :security_id
      t.decimal :quantity
      t.date :expiry_date
      t.decimal :buy_price
      t.decimal :sell_price
      t.decimal :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
