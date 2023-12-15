# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_12_07_073158) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "address_type"
    t.string "contact_name"
    t.string "cellphone"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_item_id", null: false
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_item_id"], name: "index_cart_items_on_product_item_id"
    t.index ["user_id"], name: "index_cart_items_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.integer "weight", default: 0
    t.integer "products_counter", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["title"], name: "index_categories_on_title"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.string "hex_code"
    t.integer "weight", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_favorites_on_product_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "product_colors", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "color_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["color_id"], name: "index_product_colors_on_color_id"
    t.index ["product_id"], name: "index_product_colors_on_product_id"
  end

  create_table "product_items", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "color_id"
    t.integer "size_id"
    t.decimal "msrp", precision: 10, scale: 2, default: "0.0"
    t.integer "amount", default: 0
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["color_id"], name: "index_product_items_on_color_id"
    t.index ["product_id", "size_id", "color_id"], name: "index_product_items_on_product_id_and_size_id_and_color_id"
    t.index ["product_id"], name: "index_product_items_on_product_id"
    t.index ["size_id"], name: "index_product_items_on_size_id"
  end

  create_table "product_sizes", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "size_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_sizes_on_product_id"
    t.index ["size_id"], name: "index_product_sizes_on_size_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "title"
    t.string "status", default: "off"
    t.string "uuid"
    t.decimal "msrp", precision: 10, scale: 2, default: "0.0"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.boolean "has_color", default: false
    t.boolean "has_size", default: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["status", "category_id"], name: "index_products_on_status_and_category_id"
    t.index ["title"], name: "index_products_on_title"
    t.index ["uuid"], name: "index_products_on_uuid", unique: true
  end

  create_table "records", force: :cascade do |t|
    t.integer "behaviour", null: false
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.integer "amount", default: 0
    t.decimal "money", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["behaviour"], name: "index_records_on_behaviour"
    t.index ["product_id"], name: "index_records_on_product_id"
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
    t.integer "weight", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transaction_items", force: :cascade do |t|
    t.integer "transaction_order_id", null: false
    t.integer "product_item_id", null: false
    t.integer "amount"
    t.decimal "money", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_item_id"], name: "index_transaction_items_on_product_item_id"
    t.index ["transaction_order_id"], name: "index_transaction_items_on_transaction_order_id"
  end

  create_table "transaction_orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.decimal "total_money", precision: 10, scale: 2
    t.string "order_no"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_payed", default: false
    t.boolean "is_delivered", default: false
    t.boolean "is_over", default: false
    t.index ["address_id"], name: "index_transaction_orders_on_address_id"
    t.index ["is_delivered"], name: "index_transaction_orders_on_is_delivered"
    t.index ["is_over"], name: "index_transaction_orders_on_is_over"
    t.index ["is_payed"], name: "index_transaction_orders_on_is_payed"
    t.index ["order_no"], name: "index_transaction_orders_on_order_no", unique: true
    t.index ["user_id"], name: "index_transaction_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "default_address_id"
    t.boolean "is_admin", default: false
    t.string "username"
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_items", "product_items"
  add_foreign_key "cart_items", "users"
  add_foreign_key "favorites", "products"
  add_foreign_key "favorites", "users"
  add_foreign_key "product_colors", "colors"
  add_foreign_key "product_colors", "products"
  add_foreign_key "product_items", "colors"
  add_foreign_key "product_items", "products"
  add_foreign_key "product_items", "sizes"
  add_foreign_key "product_sizes", "products"
  add_foreign_key "product_sizes", "sizes"
  add_foreign_key "products", "categories"
  add_foreign_key "records", "products"
  add_foreign_key "records", "users"
  add_foreign_key "transaction_items", "product_items"
  add_foreign_key "transaction_items", "transaction_orders"
  add_foreign_key "transaction_orders", "addresses"
  add_foreign_key "transaction_orders", "users"
end
