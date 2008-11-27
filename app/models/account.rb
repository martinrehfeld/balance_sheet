class Account < ActiveRecord::Base
  belongs_to :risk_class
  has_many   :entries
end
