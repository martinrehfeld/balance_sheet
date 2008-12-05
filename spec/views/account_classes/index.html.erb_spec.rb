require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/account_classes/index.html.erb" do
  include AccountClassesHelper
  
  before(:each) do
    assigns[:account_classes] = [
      stub_model(AccountClass,
        :name => "value for name"
      ),
      stub_model(AccountClass,
        :name => "value for name"
      )
    ]
  end

  it "should render list of account_classes" do
    render "/account_classes/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
  end
end

