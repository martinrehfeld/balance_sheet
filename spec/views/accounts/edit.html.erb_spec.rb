require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/edit.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = @account = stub_model(Account,
      :new_record? => false,
      :name => "value for name",
      :liability => false,
      :notes => "value for notes"
    )
  end

  it "should render edit form" do
    render "/accounts/edit.html.erb"
    
    response.should have_tag("form[action=#{account_path(@account)}][method=post]") do
      with_tag('input#account_name[name=?]', "account[name]")
      with_tag('input#account_liability[name=?]', "account[liability]")
      with_tag('textarea#account_notes[name=?]', "account[notes]")
    end
  end
end


