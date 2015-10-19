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

ActiveRecord::Schema.define(version: 20151016110402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "alerts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "email_address_id",                null: false
    t.text     "tags",             default: [],                array: true
    t.string   "category"
    t.datetime "last_sent_at"
    t.boolean  "active",           default: true, null: false
    t.string   "frequency",                       null: false
  end

  add_index "alerts", ["email_address_id"], name: "index_alerts_on_email_address_id", using: :btree

  create_table "alerts_jobs", id: false, force: :cascade do |t|
    t.uuid    "alert_id", null: false
    t.integer "job_id",   null: false
  end

  add_index "alerts_jobs", ["alert_id"], name: "index_alerts_jobs_on_alert_id", using: :btree
  add_index "alerts_jobs", ["job_id"], name: "index_alerts_jobs_on_job_id", using: :btree

  create_table "email_addresses", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",            null: false
    t.datetime "validated_at"
    t.datetime "unsubscribed_at"
    t.text     "validation_token"
    t.text     "login_token"
  end

  add_index "email_addresses", ["email"], name: "index_email_addresses_on_email", unique: true, using: :btree
  add_index "email_addresses", ["unsubscribed_at"], name: "index_email_addresses_on_unsubscribed_at", using: :btree
  add_index "email_addresses", ["validated_at"], name: "index_email_addresses_on_validated_at", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "title",             null: false
    t.datetime "posted_at",         null: false
    t.string   "company",           null: false
    t.string   "location",          null: false
    t.text     "description",       null: false
    t.string   "company_url"
    t.string   "original_post_url"
    t.string   "source"
    t.string   "slug"
    t.string   "type"
    t.string   "category"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  add_foreign_key "alerts", "email_addresses"
  add_foreign_key "alerts_jobs", "alerts"
  add_foreign_key "alerts_jobs", "jobs"
end
