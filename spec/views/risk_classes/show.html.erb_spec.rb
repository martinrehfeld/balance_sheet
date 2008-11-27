require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/risk_classes/show.html.erb" do
  include RiskClassesHelper
  before(:each) do
    assigns[:risk_class] = @risk_class = stub_model(RiskClass,
      :name => "value for name",
      :color => "value for color"
    )
  end

  it "should render attributes in <p>" do
    render "/risk_classes/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ color/)
  end
end

