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

ActiveRecord::Schema.define(version: 20160922151214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch_failures", force: :cascade do |t|
    t.integer  "batch_id",                  null: false
    t.integer  "klass_id"
    t.json     "csv_data",     default: {}
    t.text     "klass_errors", default: [],              array: true
    t.string   "result"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "batch_failures", ["batch_id"], name: "index_batch_failures_on_batch_id", using: :btree

  create_table "batches", force: :cascade do |t|
    t.string   "file",                                 null: false
    t.string   "batch_type",                           null: false
    t.string   "status",           default: "created", null: false
    t.integer  "success_ids",      default: [],                     array: true
    t.text     "general_failures", default: [],                     array: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contacts", ["email"], name: "index_contacts_on_email", using: :btree
  add_index "contacts", ["last_name"], name: "index_contacts_on_last_name", using: :btree

  add_foreign_key "batch_failures", "batches"
end
