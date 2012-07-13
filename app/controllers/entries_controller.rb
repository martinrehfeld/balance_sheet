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
      format.ext_json { render :json => @entries.to_ext_json(:methods => [:account_name, :account_identifier, :entry_type_name, :account_balance], :class => Entry, :count => count_entries) }
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
    @entries = Entry.in_visible_account.find(:all, options_from_pagination_state(pagination_state).merge(options_from_search(Entry)))
  end

  def count_entries
    Entry.in_visible_account.count(options_from_search(Entry))
  end

  def normalize_value
    # ExtJS sadly submits a localized value to us, so we have to make sure it is parsable to a valid float ourselves
    if params[:entry] && params[:entry][:value] && I18n.t('number.format.separator') != '.'
      params[:entry][:value].gsub!(/#{I18n.t 'number.format.separator'}/, '.')
    end
  end

  # as we are using the in_visible_account scope we must make sure that the sort field is properly prefixed with then entries table name
  def options_from_pagination_state_with_entries_prefix(pagination_state)
    unless pagination_state[:sort_field].blank? || pagination_state[:sort_field] =~ /^entries\./
      pagination_state[:sort_field] = "entries.#{pagination_state[:sort_field]}"
    end

    options_from_pagination_state_without_entries_prefix(pagination_state)
  end
  alias_method_chain :options_from_pagination_state, :entries_prefix

end
