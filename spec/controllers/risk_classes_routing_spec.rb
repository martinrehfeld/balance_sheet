require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RiskClassesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "risk_classes", :action => "index").should == "/risk_classes"
    end
  
    it "should map #new" do
      route_for(:controller => "risk_classes", :action => "new").should == "/risk_classes/new"
    end
  
    it "should map #show" do
      route_for(:controller => "risk_classes", :action => "show", :id => 1).should == "/risk_classes/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "risk_classes", :action => "edit", :id => 1).should == "/risk_classes/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "risk_classes", :action => "update", :id => 1).should == "/risk_classes/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "risk_classes", :action => "destroy", :id => 1).should == "/risk_classes/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/risk_classes").should == {:controller => "risk_classes", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/risk_classes/new").should == {:controller => "risk_classes", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/risk_classes").should == {:controller => "risk_classes", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/risk_classes/1").should == {:controller => "risk_classes", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/risk_classes/1/edit").should == {:controller => "risk_classes", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/risk_classes/1").should == {:controller => "risk_classes", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/risk_classes/1").should == {:controller => "risk_classes", :action => "destroy", :id => "1"}
    end
  end
end
