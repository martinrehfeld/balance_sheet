class BalanceSheetController < ApplicationController
  
  before_filter :populate_balances_dataset, :only => :index
  before_filter :populate_future_payments_dataset, :only => [:index, :future_payments]
  
  def index
    @colors  = RiskClass.all(:order => 'id').collect{|e| [e.id, { :debit => e.debit_color || "000000", :credit => e.credit_color || "000000", :label => e.name }] }
    respond_to do |format|
      format.html # index.html.erb
      format.png { redirect_to view_helper.balances_by_risk_class_chart_url(@balances_dataset, @colors) }
    end
  end
  
  def future_payments
    respond_to do |format|
      format.png { redirect_to view_helper.future_payments_chart_url(@future_payments_dataset) }
    end
  end
  
private

  def populate_balances_dataset
    ltm_from = Date.today << 11
    ltm_to   = Date.today
    @balances_dataset = BalanceSheet.monthly_totals(ltm_from.year, ltm_from.month, ltm_to.year, ltm_to.month)
  end
  
  def populate_future_payments_dataset
    @future_payments_dataset = BalanceSheet.future_payments(Date.today)
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
