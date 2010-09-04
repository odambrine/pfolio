require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :date => Date.today,
      :portfolio_id => 1,
      :security_id => 1,
      :operation => "value for operation",
      :quantity => 9.99,
      :price => 9.99,
      :cost => 9.99
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
end
