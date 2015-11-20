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

ActiveRecord::Schema.define(version: 20151120110211) do

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
    t.integer  "order"
    t.string   "number"
    t.string   "nature"
  end

  create_table "articles_sections", id: false, force: :cascade do |t|
    t.integer "section_id", null: false
    t.integer "article_id", null: false
  end

  add_index "articles_sections", ["section_id", "article_id"], name: "index_articles_sections_on_section_id_and_article_id", using: :btree

  create_table "codes", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "escape_title"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "title"
    t.integer  "level"
    t.string   "state"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "code_id"
    t.string   "id_section_origin"
    t.integer  "order"
    t.string   "id_section_parent_origin"
  end

  add_index "sections", ["code_id"], name: "index_sections_on_code_id", using: :btree

  add_foreign_key "sections", "codes"
end
