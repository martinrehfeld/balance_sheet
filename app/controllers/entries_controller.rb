class EntriesController < ApplicationController
  
  include ExtScaffold

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :json => { :success => false }, :status => :not_found
  end
  before_filter :find_entries, :only => [ :index ]
  before_filter :find_entry, :only => [ :update, :destroy ]
  before_filter :normalize_value, :only => [ :create, :update ]

  # GET /entries
  # GET /entries.ext_json
  def index
    Account.clear_cache # make sure account total balances get re-calculated
    respond_to do |format|
      format.html     # index.html.erb (no data required)
      format.ext_json { render :json => @entries.to_ext_json(:methods => [:account_name, :entry_type_name, :account_balance], :class => Entry, :count => Entry.count(options_from_search(Entry))) }
    end
  end

  # POST /entries
  def create
    @entry = Entry.new(params[:entry])
    render :json => @entry.to_ext_json(:success => @entry.save)
  end

  # PUT /entries/1
  def update
    render :json => @entry.to_ext_json(:success => @entry.update_attributes(params[:entry]))
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
    head :ok
  end
  
protected
  
  def find_entry
    @entry = Entry.find(params[:id])
  end
  
  def find_entries
    pagination_state = update_pagination_state_with_params!(Entry)
    @entries = Entry.find(:all, options_from_pagination_state(pagination_state).merge(options_from_search(Entry)))
  end
  
  def normalize_value
    # ExtJS sadly submits a localized value to us, so we have to make sure it is parsable to a valid float ourselves
    if params[:entry] && params[:entry][:value]
      params[:entry][:value].gsub!(/#{I18n.t 'number.format.separator'}/, '.')
    end
  end

end
