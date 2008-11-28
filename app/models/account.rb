class Account < ActiveRecord::Base
  belongs_to :risk_class
  has_many   :entries
  
  def monthly_balance(year, month)
    last_of_month = Date.civil(year, month).end_of_month
    relevant_entries = entries_in_reverse_chronological_order(last_of_month)

    # find latest cumulative entry
    balance = relevant_entries.detect(Proc.new { Entry.new(:value => 0) }) {|e| e.entry_type.cumulative? }.value

    # add non-cumulative entries' values to balance
    relevant_entries.reject {|e| e.entry_type.cumulative? }.each {|e| balance += e.value rescue balance }
    
    self.liability? ? -balance : balance
  end
  
  def entries_in_reverse_chronological_order(last_date)
    self.entries.find(:all, :joins => :entry_type,
                      :conditions => ['entries.effective_date <= ?', last_date],
                      :order => 'effective_date DESC')
  end
end
