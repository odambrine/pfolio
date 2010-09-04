require 'spec_helper'

describe Holding do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :portfolio_id => 1,
      :admin => false
    }
  end

  it "should create a new instance given valid attributes" do
    Holding.create!(@valid_attributes)
  end
end
