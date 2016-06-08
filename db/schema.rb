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

ActiveRecord::Schema.define(version: 20160608210610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.string   "alt_ru"
    t.string   "title_ru"
    t.string   "alt_uk"
    t.string   "title_uk"
    t.string   "alt_en"
    t.string   "title_en"
    t.integer  "priority",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "product_id"
  end

  add_index "images", ["product_id"], name: "index_images_on_product_id", using: :btree

  create_table "options", force: :cascade do |t|
    t.integer  "options_group_id",                null: false
    t.string   "title_ru"
    t.string   "title_uk"
    t.string   "title_en"
    t.string   "field_type"
    t.boolean  "required",         default: true, null: false
    t.boolean  "is_active",        default: true, null: false
    t.integer  "priority"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "options_groups", force: :cascade do |t|
    t.string   "title_ru"
    t.string   "title_uk"
    t.string   "title_en"
    t.string   "constant_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "options_values", force: :cascade do |t|
    t.integer  "option_id",  null: false
    t.string   "title_ru"
    t.string   "title_uk"
    t.string   "title_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string  "title_ru"
    t.text    "description_ru"
    t.string  "url_ru"
    t.string  "title_uk"
    t.text    "description_uk"
    t.string  "url_uk"
    t.string  "title_en"
    t.text    "description_en"
    t.string  "url_en"
    t.string  "constant_name"
    t.integer "parent_page_id"
    t.boolean "active",         default: true, null: false
  end

  create_table "pages_products", force: :cascade do |t|
    t.integer "page_id"
    t.integer "product_id"
  end

  add_index "pages_products", ["page_id"], name: "index_pages_products_on_page_id", using: :btree
  add_index "pages_products", ["product_id"], name: "index_pages_products_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "title_ru"
    t.text     "description_ru"
    t.string   "url_ru"
    t.string   "title_uk"
    t.text     "description_uk"
    t.string   "url_uk"
    t.string   "title_en"
    t.text     "description_en"
    t.string   "url_en"
    t.integer  "priority",                    default: 0,    null: false
    t.integer  "base_page_id"
    t.float    "retail_price"
    t.integer  "retail_price_currency_id"
    t.float    "wholesale_price"
    t.integer  "wholesale_price_currency_id"
    t.float    "special_price"
    t.integer  "special_price_currency_id"
    t.integer  "special_link_id"
    t.boolean  "active",                      default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "products", ["base_page_id"], name: "index_products_on_base_page_id", using: :btree

  create_table "site_pages", force: :cascade do |t|
    t.integer "site_id"
    t.integer "page_id"
  end

  create_table "site_products", force: :cascade do |t|
    t.integer "site_id"
    t.integer "product_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "title_ru"
    t.string "title_uk"
    t.string "title_en"
    t.string "constant_name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.integer  "city_id"
    t.string   "address"
    t.string   "phone"
    t.string   "role"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
