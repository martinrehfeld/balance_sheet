require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/entry_types/edit.html.erb" do
  include EntryTypesHelper
  
  before(:each) do
    assigns[:entry_type] = @entry_type = stub_model(EntryType,
      :new_record? => false,
      :name => "value for name",
      :cumulative => false
    )
  end

  it "should render edit form" do
    render "/entry_types/edit.html.erb"
    
    response.should have_tag("form[action=#{entry_type_path(@entry_type)}][method=post]") do
      with_tag('input#entry_type_name[name=?]', "entry_type[name]")
      with_tag('input#entry_type_cumulative[name=?]', "entry_type[cumulative]")
    end
  end
end


