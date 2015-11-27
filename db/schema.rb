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

ActiveRecord::Schema.define(version: 20151127101722) do

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

  add_index "code_section_links", ["code_id"], name: "index_code_section_links_on_code_id"
  add_index "code_section_links", ["section_id"], name: "index_code_section_links_on_section_id"

  create_table "codes", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "escape_title"
  end

  create_table "jorftexts", force: :cascade do |t|
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

  add_index "section_article_links", ["section_id", "article_id"], name: "index_section_article_links_on_section_id_and_article_id"

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

  add_index "sections", ["code_id"], name: "index_sections_on_code_id"

end
