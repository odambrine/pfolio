require 'spec_helper'

describe Relationship do
  before(:each) do
    @valid_attributes = {
      :follower_id => 1,
      :followed_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Relationship.create!(@valid_attributes)
  end
end
