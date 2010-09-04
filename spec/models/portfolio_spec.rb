require 'spec_helper'

describe Portfolio do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :bechmark_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Portfolio.create!(@valid_attributes)
  end
end
