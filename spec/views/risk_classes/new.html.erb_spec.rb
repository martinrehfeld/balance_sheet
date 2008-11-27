require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/risk_classes/new.html.erb" do
  include RiskClassesHelper
  
  before(:each) do
    assigns[:risk_class] = stub_model(RiskClass,
      :new_record? => true,
      :name => "value for name",
      :color => "value for color"
    )
  end

  it "should render new form" do
    render "/risk_classes/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", risk_classes_path) do
      with_tag("input#risk_class_name[name=?]", "risk_class[name]")
      with_tag("input#risk_class_color[name=?]", "risk_class[color]")
    end
  end
end


