require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RiskClass do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :credit_color => "value for credit_color",
      :debit_color => "value for debit_color"
    }
  end

  it "should create a new instance given valid attributes" do
    RiskClass.create!(@valid_attributes)
  end
end
