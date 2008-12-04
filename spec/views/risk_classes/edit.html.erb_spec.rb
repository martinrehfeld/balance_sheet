require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/risk_classes/edit.html.erb" do
  include RiskClassesHelper
  
  before(:each) do
    assigns[:risk_class] = @risk_class = stub_model(RiskClass,
      :new_record? => false,
      :name => "value for name",
      :credit_color => "value for credit_color",
      :debit_color => "value for debit_color"
    )
  end

  it "should render edit form" do
    render "/risk_classes/edit.html.erb"
    
    response.should have_tag("form[action=#{risk_class_path(@risk_class)}][method=post]") do
      with_tag('input#risk_class_name[name=?]', "risk_class[name]")
      with_tag('input#risk_class_credit_color[name=?]', "risk_class[credit_color]")
      with_tag('input#risk_class_debit_color[name=?]', "risk_class[debit_color]")
    end
  end
end


