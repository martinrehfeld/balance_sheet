class BalanceSheetController < ApplicationController

  before_filter :populate_balances_dataset, :only => [:index, :asset_growth]
  before_filter :populate_future_payments_dataset, :only => [:index, :future_payments]
  before_filter :populate_account_class_dataset, :only => [:index, :account_classes]

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.png { redirect_to view_helper.balances_by_risk_class_chart_url(@balances_dataset, @balances_colors) }
    end
  end

  def asset_growth
    respond_to do |format|
      format.png { redirect_to view_helper.asset_growth_chart_url(@all_time_balances_dataset) }
    end
  end

  def future_payments
    respond_to do |format|
      format.png { redirect_to view_helper.future_payments_chart_url(@future_payments_dataset) }
    end
  end

  def account_classes
    respond_to do |format|
      format.png { redirect_to view_helper.balances_by_account_class_chart_url(@account_class_dataset, @account_class_colors) }
    end
  end

private

  def populate_balances_dataset
    atm_from = BalanceSheet.data_start_time
    ltm_from = Date.today << 11
    ltm_to   = Date.today
    @all_time_balances_dataset = BalanceSheet.monthly_totals(atm_from, ltm_to)
    @balances_dataset = @all_time_balances_dataset.select {|m| m[:date] >= ltm_from }
    @balances_colors  = RiskClass.all(:order => 'id').collect{|e| [e.id, { :debit => e.debit_color || "999999", :credit => e.credit_color || "999999", :label => e.name }] }
  end

  def populate_future_payments_dataset
    @future_payments_dataset = BalanceSheet.future_payments(Date.today.end_of_month)
  end

  def populate_account_class_dataset
    @account_class_dataset = BalanceSheet.funds_by_account_class(Date.today.end_of_month)
    @account_class_colors  = Hash[*AccountClass.all(:order => 'id').collect{|c| [c.id, { :color => c.color, :label => c.name }] }.flatten]
  end

  def view_helper
    Helper.instance
  end

  class Helper
    include Singleton
    include ::BalanceSheetHelper
    include ActionView::Helpers::TranslationHelper
    include ActionView::Helpers::NumberHelper
  end
end
