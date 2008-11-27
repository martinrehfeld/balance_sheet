class Entry < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :account
end
