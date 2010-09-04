require 'spec_helper'

describe "/securities/destroy" do
  before(:each) do
    render 'securities/destroy'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/securities/destroy])
  end
end
