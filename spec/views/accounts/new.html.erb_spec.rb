require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/new.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = stub_model(Account,
      :new_record? => true,
      :name => "value for name",
      :liability => false,
      :notes => "value for notes"
    )
  end

  it "should render new form" do
    render "/accounts/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", accounts_path) do
      with_tag("input#account_name[name=?]", "account[name]")
      with_tag("input#account_liability[name=?]", "account[liability]")
      with_tag("textarea#account_notes[name=?]", "account[notes]")
    end
  end
end


