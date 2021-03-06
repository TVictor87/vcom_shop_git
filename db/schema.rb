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

ActiveRecord::Schema.define(version: 20160713103807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "priority",       default: 0
    t.string   "categories"
    t.string   "url_ru"
    t.string   "url_uk"
    t.string   "url_en"
    t.string   "image"
    t.string   "alt_ru"
    t.string   "title_ru"
    t.string   "alt_uk"
    t.string   "title_uk"
    t.string   "alt_en"
    t.string   "title_en"
    t.string   "name_ru"
    t.string   "name_uk"
    t.string   "name_en"
    t.string   "keywords_ru"
    t.string   "keywords_uk"
    t.string   "keywords_en"
    t.text     "description_ru"
    t.text     "description_uk"
    t.text     "description_en"
    t.text     "text_ru"
    t.text     "text_uk"
    t.text     "text_en"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "categories", ["categories"], name: "index_categories_on_categories", using: :btree
  add_index "categories", ["category_id"], name: "index_categories_on_category_id", using: :btree
  add_index "categories", ["url_en"], name: "index_categories_on_url_en", using: :btree
  add_index "categories", ["url_ru"], name: "index_categories_on_url_ru", using: :btree
  add_index "categories", ["url_uk"], name: "index_categories_on_url_uk", using: :btree

  create_table "categories_option_groups", id: false, force: :cascade do |t|
    t.integer "category_id",     null: false
    t.integer "option_group_id", null: false
  end

  add_index "categories_option_groups", ["category_id", "option_group_id"], name: "c_og_index", using: :btree
  add_index "categories_option_groups", ["option_group_id", "category_id"], name: "og_c_index", using: :btree

  create_table "currencies", force: :cascade do |t|
    t.string  "title_ru"
    t.string  "title_uk"
    t.string  "title_en"
    t.string  "constant_name"
    t.decimal "value",         precision: 8, scale: 6
  end

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

  create_table "option_groups", force: :cascade do |t|
    t.string  "title_ru"
    t.string  "title_uk"
    t.string  "title_en"
    t.string  "field_type"
    t.boolean "required",   default: false, null: false
    t.boolean "active",     default: false, null: false
    t.integer "columns",    default: 1
    t.integer "priority",   default: 0,     null: false
    t.boolean "visible",    default: true,  null: false
  end

  create_table "options", force: :cascade do |t|
    t.integer "option_group_id"
    t.string  "value_ru"
    t.string  "value_uk"
    t.string  "value_en"
    t.decimal "retail_price",             precision: 8, scale: 2
    t.integer "retail_price_currency_id"
    t.integer "column",                                           default: 1
    t.integer "priority",                                         default: 0, null: false
  end

  add_index "options", ["option_group_id"], name: "index_options_on_option_group_id", using: :btree
  add_index "options", ["retail_price_currency_id"], name: "index_options_on_retail_price_currency_id", using: :btree

  create_table "options_groups", force: :cascade do |t|
    t.string   "title_ru"
    t.string   "title_uk"
    t.string   "title_en"
    t.string   "constant_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "options_products", id: false, force: :cascade do |t|
    t.integer "option_id",  null: false
    t.integer "product_id", null: false
  end

  add_index "options_products", ["option_id", "product_id"], name: "o_p_index", using: :btree
  add_index "options_products", ["product_id", "option_id"], name: "p_o_index", using: :btree

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

  create_table "product_options", force: :cascade do |t|
    t.integer "option_group_id"
    t.integer "product_id"
    t.string  "value"
    t.decimal "retail_price",                precision: 8, scale: 2
    t.integer "retail_price_currency_id_id"
  end

  add_index "product_options", ["option_group_id"], name: "index_product_options_on_option_group_id", using: :btree
  add_index "product_options", ["product_id"], name: "index_product_options_on_product_id", using: :btree
  add_index "product_options", ["retail_price_currency_id_id"], name: "index_product_options_on_retail_price_currency_id_id", using: :btree

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
    t.float    "retail_price",                               null: false
    t.integer  "retail_price_currency_id",                   null: false
    t.float    "wholesale_price"
    t.integer  "wholesale_price_currency_id"
    t.float    "special_price"
    t.integer  "special_price_currency_id"
    t.integer  "special_link_id"
    t.boolean  "active",                      default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "category_id"
  end

  add_index "products", ["active"], name: "index_products_on_active", using: :btree
  add_index "products", ["retail_price_currency_id"], name: "index_products_on_retail_price_currency_id", using: :btree
  add_index "products", ["special_price_currency_id"], name: "index_products_on_special_price_currency_id", using: :btree
  add_index "products", ["wholesale_price_currency_id"], name: "index_products_on_wholesale_price_currency_id", using: :btree

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
