require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/account_classes/new.html.erb" do
  include AccountClassesHelper
  
  before(:each) do
    assigns[:account_class] = stub_model(AccountClass,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "should render new form" do
    render "/account_classes/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", account_classes_path) do
      with_tag("input#account_class_name[name=?]", "account_class[name]")
    end
  end
end


