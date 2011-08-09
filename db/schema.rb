# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110809140238) do

  create_table "budget_posts", :force => true do |t|
    t.integer "business_unit_id", :null => false
    t.string  "name",             :null => false
  end

  create_table "budget_rows", :force => true do |t|
    t.integer "budget_post_id", :null => false
    t.integer "sum"
  end

  create_table "business_units", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "short_name",                    :null => false
    t.text     "description",                   :null => false
    t.boolean  "active",      :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "debts", :force => true do |t|
    t.string   "description",                         :null => false
    t.integer  "created_by_id",                       :null => false
    t.integer  "amount",                              :null => false
    t.integer  "person_id",                           :null => false
    t.integer  "business_unit_id",                    :null => false
    t.string   "workflow_state",   :default => "new", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "ugid",                                 :null => false
    t.string   "login",                                :null => false
    t.string   "first_name",                           :null => false
    t.string   "last_name",                            :null => false
    t.string   "email",                                :null => false
    t.string   "bank_clearing_number", :default => "", :null => false
    t.string   "bank_account_number",  :default => "", :null => false
    t.string   "bank_name",            :default => "", :null => false
    t.string   "persistence_token"
    t.string   "role",                 :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_items", :force => true do |t|
    t.integer  "product_type_id",                                                :null => false
    t.integer  "purchase_id",                                                    :null => false
    t.decimal  "amount",          :precision => 20, :scale => 2,                 :null => false
    t.string   "comment",                                        :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", :force => true do |t|
    t.string   "description",                         :null => false
    t.string   "workflow_state",   :default => "new", :null => false
    t.integer  "person_id",                           :null => false
    t.integer  "created_by_id",                       :null => false
    t.integer  "updated_by_id",                       :null => false
    t.integer  "business_unit_id",                    :null => false
    t.date     "purchased_at",                        :null => false
    t.string   "slug",             :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "budget_post_id",                      :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
