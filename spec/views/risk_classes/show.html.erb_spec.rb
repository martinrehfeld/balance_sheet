require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/risk_classes/show.html.erb" do
  include RiskClassesHelper
  before(:each) do
    assigns[:risk_class] = @risk_class = stub_model(RiskClass,
      :name => "value for name",
      :credit_color => "value for credit_color",
      :debit_color => "value for debit_color"
    )
  end

  it "should render attributes in <p>" do
    render "/risk_classes/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ credit_color/)
    response.should have_text(/value\ for\ debit_color/)
  end
end

