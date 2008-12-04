require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/risk_classes/index.html.erb" do
  include RiskClassesHelper
  
  before(:each) do
    assigns[:risk_classes] = [
      stub_model(RiskClass,
        :name => "value for name"
      ),
      stub_model(RiskClass,
        :name => "value for name"
      )
    ]
  end

  it "should render list of risk_classes" do
    render "/risk_classes/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
  end
end

