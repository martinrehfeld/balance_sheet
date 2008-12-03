class BalanceSheet
  def self.monthly_totals(from_year, from_month, to_year, to_month)
    dataset = []
    accounts = Account.all

    Date.civil(from_year, from_month).upto_by_month(Date.civil(to_year, to_month).end_of_month) do |date|
      credit = debit = 0
      credit_by_risk_class = {}
      debit_by_risk_class = {}

      accounts.each do |account|
        balance = account.monthly_total(date.year, date.month)

        if account.liability?
          debit  += balance
          debit_by_risk_class[account.risk_class_id] ||= 0
          debit_by_risk_class[account.risk_class_id] += balance
        else
          credit += balance
          credit_by_risk_class[account.risk_class_id] ||= 0
          credit_by_risk_class[account.risk_class_id] += balance
        end
      end

      dataset << {
        :date => date,
        :credit => credit,
        :credit_by_risk_class => credit_by_risk_class,
        :debit => debit,
        :debit_by_risk_class => debit_by_risk_class,
        :total => debit + credit
      }
    end
    
    dataset
  end
  
  def self.future_payments(date)
    balance  = Account.all.collect {|a| a.monthly_balance(date.year, date.month) }.sum
    payouts  = Account.all.collect {|a| a.payouts_till_month(date.year, date.month) }.sum
    deposits = Account.all.collect {|a| a.deposits_till_month(date.year, date.month) }.sum

    {
      :balance  => balance, :payouts  => payouts,:deposits => deposits,
      :total    => balance - payouts + deposits
    }
  end
end
