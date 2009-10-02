# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091002080128) do

  create_table "account_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.boolean  "liability"
    t.integer  "risk_class_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_balance_as_future_payment"
    t.integer  "account_class_id"
    t.boolean  "hidden"
  end

  create_table "entries", :force => true do |t|
    t.integer  "account_id"
    t.date     "effective_date"
    t.integer  "entry_type_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "entry_types", :force => true do |t|
    t.string   "name"
    t.boolean  "cumulative"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_classes", :force => true do |t|
    t.string   "name"
    t.string   "credit_color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "debit_color"
  end

end
