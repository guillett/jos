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

ActiveRecord::Schema.define(version: 20151207100533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_versions", id: false, force: :cascade do |t|
    t.integer "article_a_id", null: false
    t.integer "article_b_id", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string   "id_article_origin"
    t.string   "state"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "nota"
    t.string   "text"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "number"
    t.string   "nature"
  end

  create_table "code_section_links", force: :cascade do |t|
    t.integer  "code_id"
    t.integer  "section_id"
    t.string   "state"
    t.integer  "order"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "code_section_links", ["code_id"], name: "index_code_section_links_on_code_id", using: :btree
  add_index "code_section_links", ["section_id"], name: "index_code_section_links_on_section_id", using: :btree

  create_table "codes", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "escape_title"
  end

  create_table "history_links", force: :cascade do |t|
    t.string   "id_text_origin"
    t.string   "nature"
    t.string   "text_number"
    t.string   "text_type"
    t.string   "title"
    t.integer  "article_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "history_links", ["article_id"], name: "index_history_links_on_article_id", using: :btree

  create_table "jarticles", force: :cascade do |t|
    t.string   "id_jarticle_origin"
    t.text     "text"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "jarticles", ["id_jarticle_origin"], name: "index_jarticles_on_id_jarticle_origin", unique: true, using: :btree

  create_table "jorfcont_jtext_links", id: false, force: :cascade do |t|
    t.integer "jorfcont_id", null: false
    t.integer "jtext_id",    null: false
    t.string  "title"
  end

  add_index "jorfcont_jtext_links", ["jorfcont_id", "jtext_id"], name: "index_jorfcont_jtext_links_on_jorfcont_id_and_jtext_id", using: :btree

  create_table "jorfconts", force: :cascade do |t|
    t.string   "id_jorfcont_origin"
    t.string   "nature"
    t.string   "title"
    t.integer  "number"
    t.datetime "publication_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "jsection_jarticle_links", id: false, force: :cascade do |t|
    t.integer "jsection_id", null: false
    t.integer "jarticle_id", null: false
    t.integer "number"
  end

  add_index "jsection_jarticle_links", ["jsection_id", "jarticle_id"], name: "index_jsection_jarticle_links_on_jsection_id_and_jarticle_id", using: :btree

  create_table "jsections", force: :cascade do |t|
    t.string   "id_jsection_origin"
    t.string   "title"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "jtext_jarticle_links", id: false, force: :cascade do |t|
    t.integer "jtext_id",    null: false
    t.integer "jarticle_id", null: false
    t.integer "order"
  end

  add_index "jtext_jarticle_links", ["jtext_id", "jarticle_id"], name: "index_jtext_jarticle_links_on_jtext_id_and_jarticle_id", using: :btree

  create_table "jtext_jsection_links", id: false, force: :cascade do |t|
    t.integer "jtext_id",    null: false
    t.integer "jsection_id", null: false
    t.integer "order"
  end

  add_index "jtext_jsection_links", ["jtext_id", "jsection_id"], name: "index_jtext_jsection_links_on_jtext_id_and_jsection_id", using: :btree

  create_table "jtexts", force: :cascade do |t|
    t.string   "id_jorftext_origin"
    t.string   "nature"
    t.integer  "sequence_number"
    t.string   "nor"
    t.datetime "publication_date"
    t.datetime "text_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "title_full"
    t.string   "permanent_link"
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "jtext_id"
  end

  add_index "keywords", ["jtext_id"], name: "index_keywords_on_jtext_id", using: :btree
  add_index "keywords", ["label"], name: "index_keywords_on_label", using: :btree

  create_table "section_article_links", id: false, force: :cascade do |t|
    t.integer  "section_id", null: false
    t.integer  "article_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "state"
    t.integer  "order"
  end

  add_index "section_article_links", ["section_id", "article_id"], name: "index_section_article_links_on_section_id_and_article_id", using: :btree

  create_table "section_links", force: :cascade do |t|
    t.string   "state"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "source_id",  null: false
    t.integer  "target_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "code_id"
    t.string   "id_section_origin"
  end

  add_index "sections", ["code_id"], name: "index_sections_on_code_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "history_links", "articles"
  add_foreign_key "keywords", "jtexts"
end
