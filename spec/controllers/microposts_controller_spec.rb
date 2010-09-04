require 'spec_helper'

describe MicropostsController do

  integrate_views

  describe "access control" do
  
  it "should deny access to 'create'" do
    post :create
    response.should redirect_to(signin_path)    
  end
  
  it "should deny access to 'destroy'" do
    delete :destroy
    response.should redirect_to(signin_path)
  end
    
end
