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

ActiveRecord::Schema.define(version: 20140618173552) do

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.integer  "district_id"
    t.integer  "school_id"
    t.integer  "campaignable_id"
    t.boolean  "active",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "campaignable_type"
    t.boolean  "school_wide",          default: false
    t.integer  "goal_amount_cents",    default: 0,     null: false
    t.string   "goal_amount_currency", default: "USD", null: false
  end

  add_index "campaigns", ["campaignable_id"], name: "index_campaigns_on_campaignable_id", using: :btree
  add_index "campaigns", ["district_id"], name: "index_campaigns_on_district_id", using: :btree
  add_index "campaigns", ["school_id"], name: "index_campaigns_on_school_id", using: :btree
  add_index "campaigns", ["slug"], name: "index_campaigns_on_slug", unique: true, using: :btree
  add_index "campaigns", ["state_id"], name: "index_campaigns_on_state_id", using: :btree

  create_table "contributions", force: true do |t|
    t.integer  "pledge_id"
    t.date     "pledged_at"
    t.integer  "contributor_id"
    t.integer  "campaign_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contributions", ["campaign_id"], name: "index_contributions_on_campaign_id", using: :btree
  add_index "contributions", ["contributor_id"], name: "index_contributions_on_contributor_id", using: :btree

  create_table "contributors", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["state_id"], name: "index_districts_on_state_id", using: :btree

  create_table "schools", force: true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["district_id"], name: "index_schools_on_district_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teachers", ["school_id"], name: "index_teachers_on_school_id", using: :btree

  create_table "tos", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
