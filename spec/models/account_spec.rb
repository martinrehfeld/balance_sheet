require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :liability => false,
      :risk_class_id => "1",
      :notes => "value for notes"
    }
  end

  it "should create a new instance given valid attributes" do
    Account.create!(@valid_attributes)
  end
end
