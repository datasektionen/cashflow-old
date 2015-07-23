# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141228153158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "budget_posts", force: :cascade do |t|
    t.integer "business_unit_id",                    null: false
    t.string  "name",                    limit: 255, null: false
    t.integer "mage_arrangement_number",             null: false
  end

  create_table "budget_rows", force: :cascade do |t|
    t.integer "budget_post_id",             null: false
    t.integer "year",                       null: false
    t.integer "sum",            default: 0, null: false
  end

  create_table "business_units", force: :cascade do |t|
    t.string   "name",                limit: 255,                null: false
    t.string   "short_name",          limit: 255,                null: false
    t.text     "description",                                    null: false
    t.boolean  "active",                          default: true, null: false
    t.string   "email",               limit: 255, default: "",   null: false
    t.integer  "mage_number",                                    null: false
    t.string   "mage_default_series", limit: 255,                null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "ugid",                 limit: 255,              null: false
    t.string   "login",                limit: 255,              null: false
    t.string   "first_name",           limit: 255,              null: false
    t.string   "last_name",            limit: 255,              null: false
    t.string   "email",                limit: 255,              null: false
    t.string   "bank_clearing_number", limit: 255, default: "", null: false
    t.string   "bank_account_number",  limit: 255, default: "", null: false
    t.string   "bank_name",            limit: 255, default: "", null: false
    t.string   "persistence_token",    limit: 255
    t.string   "role",                 limit: 255, default: "", null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name",                limit: 255, null: false
    t.string   "description",         limit: 255, null: false
    t.integer  "mage_account_number",             null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "purchase_items", force: :cascade do |t|
    t.integer  "product_type_id",                                                   null: false
    t.integer  "purchase_id",                                                       null: false
    t.decimal  "amount",                      precision: 20, scale: 2,              null: false
    t.string   "comment",         limit: 255,                          default: "", null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.string   "description",    limit: 255,                 null: false
    t.string   "workflow_state", limit: 255, default: "new", null: false
    t.integer  "person_id",                                  null: false
    t.integer  "budget_post_id",                             null: false
    t.integer  "year",                                       null: false
    t.date     "purchased_on",                               null: false
    t.string   "slug",           limit: 255, default: "",    null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 255, null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
