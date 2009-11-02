class Account < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :risk_class
  belongs_to :account_class
  has_many   :entries, :dependent => :destroy
  
  named_scope :visible, :conditions => ['hidden IS NULL OR hidden = ?', false]
  
  def total(date = Date.civil(9999,12,31))
    total = inverted_balance(date, true)

    # add non-cumulative entries' values to balance
    entries_in_reverse_chronological_order(date).reject {|e| e.entry_type.cumulative? }.each do |e|
      total += e.value if e.value
    end

    liability_corrected_value total
  end
  
  def balance(date = Date.civil(9999,12,31), include_future_payment_balance = false)
    return 0.0 if self.show_balance_as_future_payment? && !include_future_payment_balance
    
    # find latest cumulative entry
    balance = entries_in_reverse_chronological_order(date).detect(Proc.new { Entry.new(:value => 0) }) {|e| e.entry_type.cumulative? }.value

    liability_corrected_value balance
  end
  
  def inverted_balance(date = Date.civil(9999,12,31), include_future_payment_balance = false)
    total = balance(date, include_future_payment_balance)
    liability_corrected_value total
  end
  
  def payouts_till(date)
    payouts = self.show_balance_as_future_payment ? inverted_balance(date, true) : 0.0
    payouts = 0.0 unless self.liability?
      
    payouts += non_cumulative_entry_sum(date) {|e|
      if self.liability?
        e.value > 0 ? e.value : 0.0
      else
        e.value < 0 ? -e.value : 0.0
      end
    }
  end
  
  def deposits_till(date)
    deposits = self.show_balance_as_future_payment ? inverted_balance(date, true) : 0.0
    deposits = 0.0 if self.liability?
  
    deposits += non_cumulative_entry_sum(date) {|e|
      if self.liability?
        e.value > 0 ? 0.0 : -e.value
      else
        e.value < 0 ? 0.0 : e.value
      end
    }
  end

  class << self
    extend ActiveSupport::Memoizable
    
    # provide a memoized class method to sum up all entries
    # memoization helps putting this information in a virtual attribute of Entry without much DB overhead
    def total_balance(id)
      Account.find(id).total
    end
    memoize :total_balance
    
    def clear_cache
      unmemoize_all
    end
  end

private

  def entries_in_reverse_chronological_order(last_date)
    self.entries.find(:all, :joins => :entry_type,
                      :conditions => ['entries.effective_date <= ?', last_date],
                      :order => 'effective_date DESC')
  end
  memoize :entries_in_reverse_chronological_order
  
  def non_cumulative_entry_sum(date, &block)
    block ||= Proc.new {|e| e.value}
    entries_in_reverse_chronological_order(date).reject {|e|
      e.entry_type.cumulative? || e.value.nil?
    }.map(&block).sum || 0.0
  end
  
  def liability_corrected_value(value) 
    self.liability? ? -value : value
  end
end
