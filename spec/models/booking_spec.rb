require 'spec_helper'

describe Booking do
  before(:each) do
    @valid_attributes = {
      :date => Date.today,
      :security_id => 1,
      :quantity => 9.99,
      :expiry_date => Date.today,
      :buy_price => 9.99,
      :sell_price => 9.99,
      :cost => 9.99
    }
  end

  it "should create a new instance given valid attributes" do
    Booking.create!(@valid_attributes)
  end
end
