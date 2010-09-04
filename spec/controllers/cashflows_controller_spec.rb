require 'spec_helper'

describe CashflowsController do

  #Delete these examples and add some real ones
  it "should use CashflowsController" do
    controller.should be_an_instance_of(CashflowsController)
  end


  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get 'destroy'
      response.should be_success
    end
  end
end
