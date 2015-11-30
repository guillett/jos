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

ActiveRecord::Schema.define(version: 20151130101100) do

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

  create_table "jorfcont_jorftext_links", id: false, force: :cascade do |t|
    t.integer "jorfcont_id", null: false
    t.integer "jorftext_id", null: false
  end

  add_index "jorfcont_jorftext_links", ["jorfcont_id", "jorftext_id"], name: "index_jorfcont_jorftext_links_on_jorfcont_id_and_jorftext_id", using: :btree

  create_table "jorfconts", force: :cascade do |t|
    t.string   "id_jorfcont_origin"
    t.string   "nature"
    t.string   "title"
    t.integer  "number"
    t.datetime "publication_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "jtexts", force: :cascade do |t|
    t.string   "id_jorftext_origin"
    t.string   "nature"
    t.integer  "sequence_number"
    t.string   "nor"
    t.datetime "publication_date"
    t.datetime "text_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

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

  add_foreign_key "section_links", "sections", column: "source_id"
  add_foreign_key "section_links", "sections", column: "target_id"
  add_foreign_key "sections", "codes"
end
