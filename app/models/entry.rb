class Entry < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :account
  
  def account_name
    account && account.name
  end
  
  def entry_type_name
    entry_type && entry_type.name
  end
  
  def account_balance
    account && Account.total_balance(account)
  end
end
