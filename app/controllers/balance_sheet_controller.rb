class BalanceSheetController < ApplicationController
  def index
    ltm_from = Date.today << 11
    ltm_to   = Date.today
    @dataset = BalanceSheet.monthly_balances(ltm_from.year, ltm_from.month, ltm_to.year, ltm_to.month)
    @colors  = RiskClass.all(:order => 'id').collect{|e| [e.id, { :debit => e.color, :credit => e.color, :label => e.name }] }
    respond_to do |format|
      format.html # index.html.erb
      format.png { redirect_to view_helper.google_chart_url(@dataset, @colors) }
    end
  end
  
private

  def view_helper
    Helper.instance
  end
  
  class Helper
    include Singleton
    include ::BalanceSheetHelper
  end
end