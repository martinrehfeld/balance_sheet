require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/show.html.erb" do
  include AccountsHelper
  before(:each) do
    assigns[:account] = @account = stub_model(Account,
      :name => "value for name",
      :liability => false,
      :notes => "value for notes"
    )
  end

  it "should render attributes in <p>" do
    render "/accounts/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/als/)
    response.should have_text(/value\ for\ notes/)
  end
end

