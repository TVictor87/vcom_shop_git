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

ActiveRecord::Schema.define(version: 20_151_029_143_203) do
  create_table 'currencies', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.string 'short_name', limit: 255
    t.string 'sign',       limit: 255
    t.float 'value', limit: 24
    t.boolean 'is_base'
    t.datetime 'created_at',             null: false
    t.datetime 'updated_at',             null: false
  end

  create_table 'images', force: :cascade do |t|
    t.string 'image',      limit: 255
    t.string 'alt_ru',     limit: 255
    t.string 'title_ru',   limit: 255
    t.string 'alt_uk',     limit: 255
    t.string 'title_uk',   limit: 255
    t.string 'alt_en',     limit: 255
    t.string 'title_en',   limit: 255
    t.integer 'priority', limit: 4, default: 0, null: false
    t.datetime 'created_at',                         null: false
    t.datetime 'updated_at',                         null: false
  end

  create_table 'options', force: :cascade do |t|
    t.integer 'options_group_id', limit: 4, null: false
    t.string 'title_ru',         limit: 255
    t.string 'title_uk',         limit: 255
    t.string 'title_en',         limit: 255
    t.string 'field_type',       limit: 255
    t.boolean 'required',                     default: true, null: false
    t.boolean 'is_active',                    default: true, null: false
    t.integer 'priority', limit: 4
    t.datetime 'created_at',                                  null: false
    t.datetime 'updated_at',                                  null: false
  end

  create_table 'options_groups', force: :cascade do |t|
    t.string 'title_ru',      limit: 255
    t.string 'title_uk',      limit: 255
    t.string 'title_en',      limit: 255
    t.string 'constant_name', limit: 255
    t.datetime 'created_at',                null: false
    t.datetime 'updated_at',                null: false
  end

  create_table 'options_values', force: :cascade do |t|
    t.integer 'option_id', limit: 4, null: false
    t.string 'title_ru',   limit: 255
    t.string 'title_uk',   limit: 255
    t.string 'title_en',   limit: 255
    t.datetime 'created_at',             null: false
    t.datetime 'updated_at',             null: false
  end

  create_table 'page_products', force: :cascade do |t|
    t.integer 'page_id',    limit: 4
    t.integer 'product_id', limit: 4
  end

  create_table 'pages', force: :cascade do |t|
    t.string 'title_ru',       limit: 255
    t.text 'description_ru', limit: 65_535
    t.string 'url_ru',         limit: 255
    t.string 'title_uk',       limit: 255
    t.text 'description_uk', limit: 65_535
    t.string 'url_uk',         limit: 255
    t.string 'title_en',       limit: 255
    t.text 'description_en', limit: 65_535
    t.string 'url_en',         limit: 255
    t.string 'constant_name',  limit: 255
    t.integer 'parent_page_id', limit: 4
    t.boolean 'active', default: true, null: false
  end

  create_table 'product_images', force: :cascade do |t|
    t.integer 'product_id', limit: 4
    t.integer 'image_id',   limit: 4
  end

  create_table 'products', force: :cascade do |t|
    t.string 'title_ru', limit: 255
    t.text 'description_ru', limit: 65_535
    t.string 'url_ru',                      limit: 255
    t.string 'title_uk',                    limit: 255
    t.text 'description_uk', limit: 65_535
    t.string 'url_uk',                      limit: 255
    t.string 'title_en',                    limit: 255
    t.text 'description_en', limit: 65_535
    t.string 'url_en', limit: 255
    t.integer 'priority',                    limit: 4, default: 0, null: false
    t.integer 'base_page_id',                limit: 4
    t.float 'retail_price', limit: 24
    t.integer 'retail_price_currency_id', limit: 4
    t.float 'wholesale_price', limit: 24
    t.integer 'wholesale_price_currency_id', limit: 4
    t.float 'special_price', limit: 24
    t.integer 'special_price_currency_id',   limit: 4
    t.integer 'special_link_id',             limit: 4
    t.boolean 'active', default: true, null: false
    t.datetime 'created_at',                                               null: false
    t.datetime 'updated_at',                                               null: false
  end

  create_table 'site_pages', force: :cascade do |t|
    t.integer 'site_id', limit: 4
    t.integer 'page_id', limit: 4
  end

  create_table 'site_products', force: :cascade do |t|
    t.integer 'site_id',    limit: 4
    t.integer 'product_id', limit: 4
  end

  create_table 'sites', force: :cascade do |t|
    t.string 'title_ru',      limit: 255
    t.string 'title_uk',      limit: 255
    t.string 'title_en',      limit: 255
    t.string 'constant_name', limit: 255
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email',                  limit: 255, default: '', null: false
    t.string 'first_name',             limit: 255, default: '', null: false
    t.string 'last_name',              limit: 255, default: '', null: false
    t.integer 'city_id', limit: 4
    t.string 'address',                limit: 255
    t.string 'phone',                  limit: 255
    t.string 'role',                   limit: 255
    t.string 'encrypted_password',     limit: 255, default: '', null: false
    t.string 'reset_password_token',   limit: 255
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', limit: 4, default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip',     limit: 255
    t.string 'last_sign_in_ip',        limit: 255
    t.datetime 'created_at',                                      null: false
    t.datetime 'updated_at',                                      null: false
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
end
