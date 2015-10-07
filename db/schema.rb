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

ActiveRecord::Schema.define(version: 20151006234240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
  end

  create_table "jobs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "title",             limit: 255, null: false
    t.datetime "posted",                        null: false
    t.string   "company",           limit: 255, null: false
    t.string   "location",          limit: 255, null: false
    t.text     "description",                   null: false
    t.string   "company_url",       limit: 255
    t.string   "original_post_url", limit: 255
    t.string   "source",            limit: 255
  end

  add_foreign_key "jobs", "categories", name: "jobs_category_id_fk"
  add_foreign_key "jobs", "categories", name: "jobs_category_id_fk"
end
