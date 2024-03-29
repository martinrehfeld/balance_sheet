require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntryTypesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "entry_types", :action => "index").should == "/entry_types"
    end
  
    it "should map #new" do
      route_for(:controller => "entry_types", :action => "new").should == "/entry_types/new"
    end
  
    it "should map #show" do
      route_for(:controller => "entry_types", :action => "show", :id => 1).should == "/entry_types/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "entry_types", :action => "edit", :id => 1).should == "/entry_types/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "entry_types", :action => "update", :id => 1).should == "/entry_types/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "entry_types", :action => "destroy", :id => 1).should == "/entry_types/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/entry_types").should == {:controller => "entry_types", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/entry_types/new").should == {:controller => "entry_types", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/entry_types").should == {:controller => "entry_types", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/entry_types/1").should == {:controller => "entry_types", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/entry_types/1/edit").should == {:controller => "entry_types", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/entry_types/1").should == {:controller => "entry_types", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/entry_types/1").should == {:controller => "entry_types", :action => "destroy", :id => "1"}
    end
  end
end
