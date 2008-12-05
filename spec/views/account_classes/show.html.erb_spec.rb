require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/account_classes/show.html.erb" do
  include AccountClassesHelper
  before(:each) do
    assigns[:account_class] = @account_class = stub_model(AccountClass,
      :name => "value for name"
    )
  end

  it "should render attributes in <p>" do
    render "/account_classes/show.html.erb"
    response.should have_text(/value\ for\ name/)
  end
end

