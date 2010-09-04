require 'spec_helper'

describe "/transactions/destroy" do
  before(:each) do
    render 'transactions/destroy'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/transactions/destroy])
  end
end
