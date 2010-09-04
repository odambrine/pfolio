require 'spec_helper'

describe "/stock/create" do
  before(:each) do
    render 'stock/create'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/stock/create])
  end
end
