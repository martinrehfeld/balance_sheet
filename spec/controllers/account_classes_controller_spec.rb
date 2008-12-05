require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountClassesController do

  def mock_account_class(stubs={})
    @mock_account_class ||= mock_model(AccountClass, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all account_classes as @account_classes" do
      AccountClass.should_receive(:find).with(:all).and_return([mock_account_class])
      get :index
      assigns[:account_classes].should == [mock_account_class]
    end

    describe "with mime type of xml" do
  
      it "should render all account_classes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        AccountClass.should_receive(:find).with(:all).and_return(account_classes = mock("Array of AccountClasses"))
        account_classes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested account_class as @account_class" do
      AccountClass.should_receive(:find).with("37").and_return(mock_account_class)
      get :show, :id => "37"
      assigns[:account_class].should equal(mock_account_class)
    end
    
    describe "with mime type of xml" do

      it "should render the requested account_class as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        AccountClass.should_receive(:find).with("37").and_return(mock_account_class)
        mock_account_class.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new account_class as @account_class" do
      AccountClass.should_receive(:new).and_return(mock_account_class)
      get :new
      assigns[:account_class].should equal(mock_account_class)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested account_class as @account_class" do
      AccountClass.should_receive(:find).with("37").and_return(mock_account_class)
      get :edit, :id => "37"
      assigns[:account_class].should equal(mock_account_class)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created account_class as @account_class" do
        AccountClass.should_receive(:new).with({'these' => 'params'}).and_return(mock_account_class(:save => true))
        post :create, :account_class => {:these => 'params'}
        assigns(:account_class).should equal(mock_account_class)
      end

      it "should redirect to the created account_class" do
        AccountClass.stub!(:new).and_return(mock_account_class(:save => true))
        post :create, :account_class => {}
        response.should redirect_to(account_class_url(mock_account_class))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved account_class as @account_class" do
        AccountClass.stub!(:new).with({'these' => 'params'}).and_return(mock_account_class(:save => false))
        post :create, :account_class => {:these => 'params'}
        assigns(:account_class).should equal(mock_account_class)
      end

      it "should re-render the 'new' template" do
        AccountClass.stub!(:new).and_return(mock_account_class(:save => false))
        post :create, :account_class => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested account_class" do
        AccountClass.should_receive(:find).with("37").and_return(mock_account_class)
        mock_account_class.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :account_class => {:these => 'params'}
      end

      it "should expose the requested account_class as @account_class" do
        AccountClass.stub!(:find).and_return(mock_account_class(:update_attributes => true))
        put :update, :id => "1"
        assigns(:account_class).should equal(mock_account_class)
      end

      it "should redirect to the account_class" do
        AccountClass.stub!(:find).and_return(mock_account_class(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(account_class_url(mock_account_class))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested account_class" do
        AccountClass.should_receive(:find).with("37").and_return(mock_account_class)
        mock_account_class.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :account_class => {:these => 'params'}
      end

      it "should expose the account_class as @account_class" do
        AccountClass.stub!(:find).and_return(mock_account_class(:update_attributes => false))
        put :update, :id => "1"
        assigns(:account_class).should equal(mock_account_class)
      end

      it "should re-render the 'edit' template" do
        AccountClass.stub!(:find).and_return(mock_account_class(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested account_class" do
      AccountClass.should_receive(:find).with("37").and_return(mock_account_class)
      mock_account_class.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the account_classes list" do
      AccountClass.stub!(:find).and_return(mock_account_class(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(account_classes_url)
    end

  end

end
