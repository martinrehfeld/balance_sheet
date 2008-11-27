require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/entry_types/show.html.erb" do
  include EntryTypesHelper
  before(:each) do
    assigns[:entry_type] = @entry_type = stub_model(EntryType,
      :name => "value for name",
      :cumulative => false
    )
  end

  it "should render attributes in <p>" do
    render "/entry_types/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/als/)
  end
end

