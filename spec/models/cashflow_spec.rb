require 'spec_helper'

describe Cashflow do
  before(:each) do
    @valid_attributes = {
      :portfolio_id => 1,
      :date => Date.today,
      :amount => 9.99
    }
  end

  it "should create a new instance given valid attributes" do
    Cashflow.create!(@valid_attributes)
  end
end
