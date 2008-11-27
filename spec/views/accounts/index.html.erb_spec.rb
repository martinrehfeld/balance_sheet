require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/index.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:accounts] = [
      stub_model(Account,
        :name => "value for name",
        :liability => false,
        :notes => "value for notes"
      ),
      stub_model(Account,
        :name => "value for name",
        :liability => false,
        :notes => "value for notes"
      )
    ]
  end

  it "should render list of accounts" do
    render "/accounts/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "false", 2)
    response.should have_tag("tr>td", "value for notes", 2)
  end
end

