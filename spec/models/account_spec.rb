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
  
  describe "as credit" do
    fixtures :entry_types

    before(:each) do
      @it = Account.create!(@valid_attributes.merge(:liability => false, :show_balance_as_future_payment => false))
      @it.entries << Entry.create(:effective_date => Date.yesterday, :entry_type => entry_types(:cumulative), :value => 10000)
      @it.entries << Entry.create(:effective_date => Date.yesterday, :entry_type => entry_types(:non_cumulative), :value => 5000)
    end
    
    specify { @it.balance.should == 10000 }
    specify { @it.total.should == 15000 }
    
    describe "not to be shown as future payment" do
      it "should have no payouts" do
        @it.payouts_till(Date.today).should == 0
      end
        
      it "should have the non-cumulative entry as deposit" do
        @it.deposits_till(Date.today).should == 5000
      end
    end

    describe "to be show as future payment" do
      before(:each) do
        @it.update_attribute(:show_balance_as_future_payment, true)
      end

      it "should have no payouts" do
        @it.payouts_till(Date.today).should == 0
      end
        
      it "should be a deposit with its full total" do
        @it.deposits_till(Date.today).should == 15000
      end
    end
  end

  describe "as liablility" do
    fixtures :entry_types

    before(:each) do
      @it = Account.create!(@valid_attributes.merge(:liability => true, :show_balance_as_future_payment => false))
      @it.entries << Entry.create(:effective_date => Date.yesterday, :entry_type => entry_types(:cumulative), :value => 10000)
      @it.entries << Entry.create(:effective_date => Date.yesterday, :entry_type => entry_types(:non_cumulative), :value => 5000)
    end

    specify { @it.balance.should == -10000 }
    specify { @it.total.should == -15000 }
    
    describe "not to be shown as future payment" do
      it "should have the non-cumulative entry as payout" do
        @it.payouts_till(Date.today).should == 5000
      end
        
      it "should have no deposits" do
        @it.deposits_till(Date.today).should == 0
      end
    end

    describe "to be show as future payment" do
      before(:each) do
        @it.update_attribute(:show_balance_as_future_payment, true)
      end

      it "should be a payout with its full total" do
        @it.payouts_till(Date.today).should == 15000
      end
        
      it "should have no deposits" do
        @it.deposits_till(Date.today).should == 0
      end
    end
  end
end
