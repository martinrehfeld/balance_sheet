require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/entry_types/index.html.erb" do
  include EntryTypesHelper
  
  before(:each) do
    assigns[:entry_types] = [
      stub_model(EntryType,
        :name => "value for name",
        :cumulative => false
      ),
      stub_model(EntryType,
        :name => "value for name",
        :cumulative => false
      )
    ]
  end

  it "should render list of entry_types" do
    render "/entry_types/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "false", 2)
  end
end

