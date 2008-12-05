require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/account_classes/edit.html.erb" do
  include AccountClassesHelper
  
  before(:each) do
    assigns[:account_class] = @account_class = stub_model(AccountClass,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "should render edit form" do
    render "/account_classes/edit.html.erb"
    
    response.should have_tag("form[action=#{account_class_path(@account_class)}][method=post]") do
      with_tag('input#account_class_name[name=?]', "account_class[name]")
    end
  end
end


