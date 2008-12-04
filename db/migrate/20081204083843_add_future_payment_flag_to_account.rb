class AddFuturePaymentFlagToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :show_balance_as_future_payment, :boolean
  end

  def self.down
    remove_column :accounts, :show_balance_as_future_payment
  end
end
