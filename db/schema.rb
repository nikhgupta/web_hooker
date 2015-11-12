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

ActiveRecord::Schema.define(version: 20151112211612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "destinations", force: :cascade do |t|
    t.integer  "portal_id"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "destinations", ["portal_id"], name: "index_destinations_on_portal_id", using: :btree

  create_table "portals", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "slug"
    t.integer  "submissions_count",  default: 0
    t.integer  "destinations_count", default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "portals", ["slug"], name: "index_portals_on_slug", unique: true, using: :btree
  add_index "portals", ["user_id"], name: "index_portals_on_user_id", using: :btree

  create_table "replies", force: :cascade do |t|
    t.integer  "destination_id"
    t.integer  "submission_id"
    t.integer  "http_status_code"
    t.integer  "content_length"
    t.string   "content_type"
    t.text     "headers"
    t.text     "body"
    t.datetime "processed_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "replies", ["destination_id"], name: "index_replies_on_destination_id", using: :btree
  add_index "replies", ["submission_id"], name: "index_replies_on_submission_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "portal_id"
    t.string   "host"
    t.string   "ip"
    t.string   "uuid"
    t.string   "request_method"
    t.string   "content_type"
    t.integer  "content_length"
    t.text     "headers"
    t.text     "body"
    t.integer  "failed_replies_count",     default: 0
    t.integer  "successful_replies_count", default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "submissions", ["portal_id"], name: "index_submissions_on_portal_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.boolean  "admin",                  default: false
    t.integer  "portals_count",          default: 0
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "destinations", "portals"
  add_foreign_key "portals", "users"
  add_foreign_key "replies", "destinations"
  add_foreign_key "replies", "submissions"
  add_foreign_key "submissions", "portals"
end
