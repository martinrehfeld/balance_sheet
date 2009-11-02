class BalanceSheet
  def self.monthly_totals(from, to)
    dataset = []
    accounts = Account.all

    Date.civil(from.year, from.month).upto_by_month(Date.civil(to.year, to.month).end_of_month) do |date|
      date = date.end_of_month
      credit = debit = 0
      credit_by_risk_class, debit_by_risk_class = {}, {}

      accounts.each do |account|
        balance = account.total(date)

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
    balance  = Account.all.collect {|a| a.balance(date) }.sum
    payouts  = Account.all.collect {|a| a.payouts_till date }.sum
    deposits = Account.all.collect {|a| a.deposits_till date }.sum

    {
      :balance  => balance, :payouts => payouts, :deposits => deposits,
      :total    => balance - payouts + deposits
    }
  end
  
  def self.funds_by_account_class(date)
    # { <account_class.id> => <account_total>, ... }
    Hash[*Account.all.group_by(&:account_class).map {|e|
      [e.first && e.first.id, e.second.collect {|a|
        a.total(date)
      }.sum]
    }.flatten]
  end
end
