require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/entry_types/new.html.erb" do
  include EntryTypesHelper
  
  before(:each) do
    assigns[:entry_type] = stub_model(EntryType,
      :new_record? => true,
      :name => "value for name",
      :cumulative => false
    )
  end

  it "should render new form" do
    render "/entry_types/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", entry_types_path) do
      with_tag("input#entry_type_name[name=?]", "entry_type[name]")
      with_tag("input#entry_type_cumulative[name=?]", "entry_type[cumulative]")
    end
  end
end


