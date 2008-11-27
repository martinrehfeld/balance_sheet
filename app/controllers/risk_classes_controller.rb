class RiskClassesController < ApplicationController
  # GET /risk_classes
  # GET /risk_classes.xml
  def index
    @risk_classes = RiskClass.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @risk_classes }
    end
  end

  # GET /risk_classes/1
  # GET /risk_classes/1.xml
  def show
    @risk_class = RiskClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @risk_class }
    end
  end

  # GET /risk_classes/new
  # GET /risk_classes/new.xml
  def new
    @risk_class = RiskClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @risk_class }
    end
  end

  # GET /risk_classes/1/edit
  def edit
    @risk_class = RiskClass.find(params[:id])
  end

  # POST /risk_classes
  # POST /risk_classes.xml
  def create
    @risk_class = RiskClass.new(params[:risk_class])

    respond_to do |format|
      if @risk_class.save
        flash[:notice] = 'RiskClass was successfully created.'
        format.html { redirect_to(@risk_class) }
        format.xml  { render :xml => @risk_class, :status => :created, :location => @risk_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @risk_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /risk_classes/1
  # PUT /risk_classes/1.xml
  def update
    @risk_class = RiskClass.find(params[:id])

    respond_to do |format|
      if @risk_class.update_attributes(params[:risk_class])
        flash[:notice] = 'RiskClass was successfully updated.'
        format.html { redirect_to(@risk_class) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @risk_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /risk_classes/1
  # DELETE /risk_classes/1.xml
  def destroy
    @risk_class = RiskClass.find(params[:id])
    @risk_class.destroy

    respond_to do |format|
      format.html { redirect_to(risk_classes_url) }
      format.xml  { head :ok }
    end
  end
end
