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
  
  it "should have a scope for visible (non-hidden) accounts" do
    a1 = Account.create!(@valid_attributes)
    a2 = Account.create!(@valid_attributes.merge(:hidden => true))
    accounts = Account.visible.all
    accounts.should include(a1)
    accounts.should_not include(a2)
  end
end
