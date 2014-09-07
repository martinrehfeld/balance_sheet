class Entry < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :account

  named_scope :in_visible_account, :joins => :account, :conditions => ['accounts.hidden IS NOT NULL AND accounts.hidden <> ?', true]

  def account_name
    account && account.name
  end

  def account_identifier
    [account_name, account_id].compact.join('-')
  end

  def entry_type_name
    entry_type && entry_type.name
  end

  def account_balance
    account && Account.total_balance(account)
  end
end
