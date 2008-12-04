class Account < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :risk_class
  has_many   :entries
  
  def monthly_total(year, month)
    total = monthly_balance(year, month, true)
    total = -total if self.liability?

    # add non-cumulative entries' values to balance
    last_of_month = Date.civil(year, month).end_of_month
    entries_in_reverse_chronological_order(last_of_month).reject {|e| e.entry_type.cumulative? }.each do |e|
      total += e.value if e.value
    end

    self.liability? ? -total : total
  end
  
  def monthly_balance(year, month, include_future_payment_balance = false)
    return 0.0 if self.show_balance_as_future_payment? && !include_future_payment_balance
    
    last_of_month = Date.civil(year, month).end_of_month

    # find latest cumulative entry
    balance = entries_in_reverse_chronological_order(last_of_month).detect(Proc.new { Entry.new(:value => 0) }) {|e| e.entry_type.cumulative? }.value

    self.liability? ? -balance : balance
  end
  
  def payouts_till_month(year, month)
    if self.show_balance_as_future_payment?
      payouts = monthly_balance(year, month, true)
      payouts = -payouts if self.liability?
    else
      payouts = 0.0
    end
    payouts = 0.0 if payouts > 0
      
    last_of_month = Date.civil(year, month).end_of_month

    payouts += (entries_in_reverse_chronological_order(last_of_month).reject {|e| e.entry_type.cumulative? || e.value.nil? }.map {|e|
      if self.liability?
        e.value > 0 ? e.value : 0.0
      else
        e.value < 0 ? -e.value : 0.0
      end
    }.sum || 0.0)
  end
  
  def deposits_till_month(year, month)
    if self.show_balance_as_future_payment?
      deposits = monthly_balance(year, month, true)
      deposits = -deposits if self.liability?
    else
      deposits = 0.0
    end
    deposits = 0.0 if deposits < 0
  
    last_of_month = Date.civil(year, month).end_of_month

    deposits += (entries_in_reverse_chronological_order(last_of_month).reject {|e| e.entry_type.cumulative? || e.value.nil? }.map {|e|
      if self.liability?
        e.value > 0 ? 0.0 : -e.value
      else
        e.value < 0 ? 0.0 : e.value
      end
    }.sum || 0.0)
  end

  class << self
    extend ActiveSupport::Memoizable
    
    # provide a memoized class method to sum up all entries
    # memoization helps putting this information in a virtual attribute of Entry without much DB overhead
    def total_balance(id)
      Account.find(id).monthly_total(9999,12)
    end
    memoize :total_balance
    
    def clear_cache
      unmemoize_all
    end
  end

  def entries_in_reverse_chronological_order(last_date)
    self.entries.find(:all, :joins => :entry_type,
                      :conditions => ['entries.effective_date <= ?', last_date],
                      :order => 'effective_date DESC')
  end
  memoize :entries_in_reverse_chronological_order
end
