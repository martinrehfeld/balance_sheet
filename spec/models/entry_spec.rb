require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Entry do
  before(:each) do
    @valid_attributes = {
    }
    # t.integer  "account_id"
    # t.date     "effective_date"
    # t.integer  "entry_type_id"
    # t.float    "value"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.text     "notes"
  end

  it "should create a new instance given valid attributes" do
    Entry.create!(@valid_attributes)
  end

  describe "account_name" do
    it "should return nil when no account is associated" do
      entry = Entry.new(@valid_attributes.merge(:account_id => nil))
      entry.account_name.should be_nil
    end
    
    it "should return the account.name of an associated account" do
      entry = Entry.new(@valid_attributes.merge(:account => Account.new(:name => 'account name')))
      entry.account_name.should == 'account name'
    end
  end

  describe "entry_type_name" do
    it "should return nil when no entry_type is associated" do
      entry = Entry.new(@valid_attributes.merge(:entry_type_id => nil))
      entry.entry_type_name.should be_nil
    end
    
    it "should return the account.name of an associated account" do
      entry = Entry.new(@valid_attributes.merge(:entry_type => EntryType.new(:name => 'type name')))
      entry.entry_type_name.should == 'type name'
    end
  end
  
  describe "account_balance" do
    it "should return nil when no account is associated" do
      entry = Entry.new(@valid_attributes.merge(:entry_type_id => nil))
      entry.account_balance.should be_nil
    end
    
    it "should return the total balance of the associated account" do
      account = Account.new(:name => 'account name')
      entry = Entry.new(@valid_attributes.merge(:account => account))
      Account.should_receive(:total_balance).with(account).and_return(123)
      
      entry.account_balance.should == 123
    end
  end
  
  it "should have a scope filtering out entries in hidden accounts" do
    a1 = Account.create!(:hidden => false)
    e1 = Entry.create!(@valid_attributes.merge(:account => a1))
    a2 = Account.create!(:hidden => true)
    e2 = Entry.create!(@valid_attributes.merge(:account => a2))

    entries = Entry.in_visible_account.all
    entries.should include(e1)
    entries.should_not include(e2)
  end
end
