require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RiskClassesController do

  def mock_risk_class(stubs={})
    @mock_risk_class ||= mock_model(RiskClass, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all risk_classes as @risk_classes" do
      RiskClass.should_receive(:find).with(:all).and_return([mock_risk_class])
      get :index
      assigns[:risk_classes].should == [mock_risk_class]
    end

    describe "with mime type of xml" do
  
      it "should render all risk_classes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        RiskClass.should_receive(:find).with(:all).and_return(risk_classes = mock("Array of RiskClasses"))
        risk_classes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested risk_class as @risk_class" do
      RiskClass.should_receive(:find).with("37").and_return(mock_risk_class)
      get :show, :id => "37"
      assigns[:risk_class].should equal(mock_risk_class)
    end
    
    describe "with mime type of xml" do

      it "should render the requested risk_class as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        RiskClass.should_receive(:find).with("37").and_return(mock_risk_class)
        mock_risk_class.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new risk_class as @risk_class" do
      RiskClass.should_receive(:new).and_return(mock_risk_class)
      get :new
      assigns[:risk_class].should equal(mock_risk_class)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested risk_class as @risk_class" do
      RiskClass.should_receive(:find).with("37").and_return(mock_risk_class)
      get :edit, :id => "37"
      assigns[:risk_class].should equal(mock_risk_class)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created risk_class as @risk_class" do
        RiskClass.should_receive(:new).with({'these' => 'params'}).and_return(mock_risk_class(:save => true))
        post :create, :risk_class => {:these => 'params'}
        assigns(:risk_class).should equal(mock_risk_class)
      end

      it "should redirect to the created risk_class" do
        RiskClass.stub!(:new).and_return(mock_risk_class(:save => true))
        post :create, :risk_class => {}
        response.should redirect_to(risk_class_url(mock_risk_class))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved risk_class as @risk_class" do
        RiskClass.stub!(:new).with({'these' => 'params'}).and_return(mock_risk_class(:save => false))
        post :create, :risk_class => {:these => 'params'}
        assigns(:risk_class).should equal(mock_risk_class)
      end

      it "should re-render the 'new' template" do
        RiskClass.stub!(:new).and_return(mock_risk_class(:save => false))
        post :create, :risk_class => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested risk_class" do
        RiskClass.should_receive(:find).with("37").and_return(mock_risk_class)
        mock_risk_class.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :risk_class => {:these => 'params'}
      end

      it "should expose the requested risk_class as @risk_class" do
        RiskClass.stub!(:find).and_return(mock_risk_class(:update_attributes => true))
        put :update, :id => "1"
        assigns(:risk_class).should equal(mock_risk_class)
      end

      it "should redirect to the risk_class" do
        RiskClass.stub!(:find).and_return(mock_risk_class(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(risk_class_url(mock_risk_class))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested risk_class" do
        RiskClass.should_receive(:find).with("37").and_return(mock_risk_class)
        mock_risk_class.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :risk_class => {:these => 'params'}
      end

      it "should expose the risk_class as @risk_class" do
        RiskClass.stub!(:find).and_return(mock_risk_class(:update_attributes => false))
        put :update, :id => "1"
        assigns(:risk_class).should equal(mock_risk_class)
      end

      it "should re-render the 'edit' template" do
        RiskClass.stub!(:find).and_return(mock_risk_class(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested risk_class" do
      RiskClass.should_receive(:find).with("37").and_return(mock_risk_class)
      mock_risk_class.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the risk_classes list" do
      RiskClass.stub!(:find).and_return(mock_risk_class(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(risk_classes_url)
    end

  end

end
