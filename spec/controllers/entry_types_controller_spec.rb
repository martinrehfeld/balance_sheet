require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntryTypesController do

  def mock_entry_type(stubs={})
    @mock_entry_type ||= mock_model(EntryType, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all entry_types as @entry_types" do
      EntryType.should_receive(:find).with(:all).and_return([mock_entry_type])
      get :index
      assigns[:entry_types].should == [mock_entry_type]
    end

    describe "with mime type of xml" do
  
      it "should render all entry_types as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        EntryType.should_receive(:find).with(:all).and_return(entry_types = mock("Array of EntryTypes"))
        entry_types.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested entry_type as @entry_type" do
      EntryType.should_receive(:find).with("37").and_return(mock_entry_type)
      get :show, :id => "37"
      assigns[:entry_type].should equal(mock_entry_type)
    end
    
    describe "with mime type of xml" do

      it "should render the requested entry_type as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        EntryType.should_receive(:find).with("37").and_return(mock_entry_type)
        mock_entry_type.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new entry_type as @entry_type" do
      EntryType.should_receive(:new).and_return(mock_entry_type)
      get :new
      assigns[:entry_type].should equal(mock_entry_type)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested entry_type as @entry_type" do
      EntryType.should_receive(:find).with("37").and_return(mock_entry_type)
      get :edit, :id => "37"
      assigns[:entry_type].should equal(mock_entry_type)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created entry_type as @entry_type" do
        EntryType.should_receive(:new).with({'these' => 'params'}).and_return(mock_entry_type(:save => true))
        post :create, :entry_type => {:these => 'params'}
        assigns(:entry_type).should equal(mock_entry_type)
      end

      it "should redirect to the created entry_type" do
        EntryType.stub!(:new).and_return(mock_entry_type(:save => true))
        post :create, :entry_type => {}
        response.should redirect_to(entry_type_url(mock_entry_type))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved entry_type as @entry_type" do
        EntryType.stub!(:new).with({'these' => 'params'}).and_return(mock_entry_type(:save => false))
        post :create, :entry_type => {:these => 'params'}
        assigns(:entry_type).should equal(mock_entry_type)
      end

      it "should re-render the 'new' template" do
        EntryType.stub!(:new).and_return(mock_entry_type(:save => false))
        post :create, :entry_type => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested entry_type" do
        EntryType.should_receive(:find).with("37").and_return(mock_entry_type)
        mock_entry_type.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :entry_type => {:these => 'params'}
      end

      it "should expose the requested entry_type as @entry_type" do
        EntryType.stub!(:find).and_return(mock_entry_type(:update_attributes => true))
        put :update, :id => "1"
        assigns(:entry_type).should equal(mock_entry_type)
      end

      it "should redirect to the entry_type" do
        EntryType.stub!(:find).and_return(mock_entry_type(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(entry_type_url(mock_entry_type))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested entry_type" do
        EntryType.should_receive(:find).with("37").and_return(mock_entry_type)
        mock_entry_type.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :entry_type => {:these => 'params'}
      end

      it "should expose the entry_type as @entry_type" do
        EntryType.stub!(:find).and_return(mock_entry_type(:update_attributes => false))
        put :update, :id => "1"
        assigns(:entry_type).should equal(mock_entry_type)
      end

      it "should re-render the 'edit' template" do
        EntryType.stub!(:find).and_return(mock_entry_type(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested entry_type" do
      EntryType.should_receive(:find).with("37").and_return(mock_entry_type)
      mock_entry_type.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the entry_types list" do
      EntryType.stub!(:find).and_return(mock_entry_type(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(entry_types_url)
    end

  end

end
