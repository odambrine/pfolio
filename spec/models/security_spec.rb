require 'spec_helper'

describe Security do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :ticker => "value for ticker",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Security.create!(@valid_attributes)
  end
end
