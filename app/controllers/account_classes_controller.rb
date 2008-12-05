class AccountClassesController < ApplicationController
  # GET /account_classes
  # GET /account_classes.xml
  def index
    @account_classes = AccountClass.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @account_classes }
    end
  end

  # GET /account_classes/1
  # GET /account_classes/1.xml
  def show
    @account_class = AccountClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account_class }
    end
  end

  # GET /account_classes/new
  # GET /account_classes/new.xml
  def new
    @account_class = AccountClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account_class }
    end
  end

  # GET /account_classes/1/edit
  def edit
    @account_class = AccountClass.find(params[:id])
  end

  # POST /account_classes
  # POST /account_classes.xml
  def create
    @account_class = AccountClass.new(params[:account_class])

    respond_to do |format|
      if @account_class.save
        flash[:notice] = 'AccountClass was successfully created.'
        format.html { redirect_to(@account_class) }
        format.xml  { render :xml => @account_class, :status => :created, :location => @account_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /account_classes/1
  # PUT /account_classes/1.xml
  def update
    @account_class = AccountClass.find(params[:id])

    respond_to do |format|
      if @account_class.update_attributes(params[:account_class])
        flash[:notice] = 'AccountClass was successfully updated.'
        format.html { redirect_to(@account_class) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account_classes/1
  # DELETE /account_classes/1.xml
  def destroy
    @account_class = AccountClass.find(params[:id])
    @account_class.destroy

    respond_to do |format|
      format.html { redirect_to(account_classes_url) }
      format.xml  { head :ok }
    end
  end
end
