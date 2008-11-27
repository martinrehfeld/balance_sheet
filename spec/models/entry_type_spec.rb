require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntryType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :cumulative => false
    }
  end

  it "should create a new instance given valid attributes" do
    EntryType.create!(@valid_attributes)
  end
end
