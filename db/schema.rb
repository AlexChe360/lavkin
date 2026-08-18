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

ActiveRecord::Schema[8.1].define(version: 2026_08_18_104000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "KZT", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.string "timezone", default: "Asia/Almaty", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "business_legal_profiles", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "bin_iin", null: false
    t.string "building"
    t.string "ceo_email"
    t.string "ceo_first_name"
    t.string "ceo_last_name"
    t.string "ceo_middle_name"
    t.string "ceo_phone"
    t.string "city"
    t.string "country", default: "KZ", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "iban"
    t.string "legal_name", null: false
    t.string "legal_type", null: false
    t.string "office"
    t.string "postal_code"
    t.string "street"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_business_legal_profiles_on_account_id", unique: true
    t.index ["bin_iin"], name: "index_business_legal_profiles_on_bin_iin"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "shop_id", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_carts_on_shop_id"
    t.index ["token"], name: "index_carts_on_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.bigint "shop_id", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "position"], name: "index_categories_on_shop_id_and_position"
    t.index ["shop_id", "slug"], name: "index_categories_on_shop_id_and_slug", unique: true
    t.index ["shop_id"], name: "index_categories_on_shop_id"
  end

  create_table "inventory_count_items", force: :cascade do |t|
    t.integer "actual_quantity"
    t.datetime "created_at", null: false
    t.integer "expected_quantity", default: 0, null: false
    t.bigint "inventory_count_id", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_count_id", "product_id"], name: "idx_on_inventory_count_id_product_id_76e45704c7", unique: true
    t.index ["inventory_count_id"], name: "index_inventory_count_items_on_inventory_count_id"
    t.index ["product_id"], name: "index_inventory_count_items_on_product_id"
  end

  create_table "inventory_counts", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "location_id", null: false
    t.string "number", null: false
    t.bigint "shop_id", null: false
    t.datetime "started_at"
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_inventory_counts_on_location_id"
    t.index ["shop_id", "number"], name: "index_inventory_counts_on_shop_id_and_number", unique: true
    t.index ["shop_id"], name: "index_inventory_counts_on_shop_id"
  end

  create_table "inventory_levels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "location_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_inventory_levels_on_location_id"
    t.index ["product_id", "location_id"], name: "index_inventory_levels_on_product_id_and_location_id", unique: true
    t.index ["product_id"], name: "index_inventory_levels_on_product_id"
  end

  create_table "inventory_movements", force: :cascade do |t|
    t.string "comment"
    t.datetime "created_at", null: false
    t.bigint "location_id", null: false
    t.string "operation", null: false
    t.bigint "product_id", null: false
    t.integer "quantity_change", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id", "created_at"], name: "index_inventory_movements_on_location_id_and_created_at"
    t.index ["location_id"], name: "index_inventory_movements_on_location_id"
    t.index ["product_id", "created_at"], name: "index_inventory_movements_on_product_id_and_created_at"
    t.index ["product_id"], name: "index_inventory_movements_on_product_id"
  end

  create_table "locations", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "shop_id", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "code"], name: "index_locations_on_shop_id_and_code", unique: true
    t.index ["shop_id"], name: "index_locations_on_shop_id"
  end

  create_table "member_invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "expires_at", null: false
    t.bigint "invited_by_id", null: false
    t.string "role", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "email"], name: "index_member_invitations_on_account_id_and_email"
    t.index ["account_id"], name: "index_member_invitations_on_account_id"
    t.index ["invited_by_id"], name: "index_member_invitations_on_invited_by_id"
    t.index ["token"], name: "index_member_invitations_on_token", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.string "role", default: "staff", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.decimal "price", precision: 12, scale: 2, null: false
    t.bigint "product_id"
    t.string "product_name", null: false
    t.integer "quantity", null: false
    t.string "sku", null: false
    t.decimal "total_amount", precision: 12, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_email"
    t.string "customer_name"
    t.string "customer_phone"
    t.datetime "inventory_committed_at"
    t.string "number", null: false
    t.bigint "shop_id", null: false
    t.string "status", default: "pending", null: false
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "number"], name: "index_orders_on_shop_id_and_number", unique: true
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "payment_provider_accounts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "connected_at"
    t.datetime "created_at", null: false
    t.string "external_client_id"
    t.datetime "last_checked_at"
    t.string "merchant_id"
    t.string "provider", null: false
    t.string "request_id"
    t.string "status", default: "draft", null: false
    t.string "terminal_number"
    t.datetime "updated_at", null: false
    t.index ["account_id", "provider"], name: "index_payment_provider_accounts_on_account_id_and_provider", unique: true
    t.index ["account_id"], name: "index_payment_provider_accounts_on_account_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "category_id", null: false
    t.decimal "compare_at_price", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.boolean "featured", default: false, null: false
    t.string "name", null: false
    t.decimal "price", precision: 12, scale: 2, null: false
    t.bigint "shop_id", null: false
    t.string "sku", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["shop_id", "sku"], name: "index_products_on_shop_id_and_sku", unique: true
    t.index ["shop_id", "slug"], name: "index_products_on_shop_id_and_slug", unique: true
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.boolean "storefront_accept_orders", default: true, null: false
    t.boolean "storefront_delivery_enabled", default: false, null: false
    t.text "storefront_description"
    t.boolean "storefront_pickup_enabled", default: true, null: false
    t.datetime "storefront_published_at"
    t.boolean "storefront_show_out_of_stock", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_shops_on_account_id"
    t.index ["slug"], name: "index_shops_on_slug", unique: true
  end

  create_table "stock_transfer_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.bigint "stock_transfer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stock_transfer_items_on_product_id"
    t.index ["stock_transfer_id", "product_id"], name: "index_stock_transfer_items_on_stock_transfer_id_and_product_id", unique: true
    t.index ["stock_transfer_id"], name: "index_stock_transfer_items_on_stock_transfer_id"
  end

  create_table "stock_transfers", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "destination_location_id", null: false
    t.string "number", null: false
    t.bigint "shop_id", null: false
    t.bigint "source_location_id", null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_location_id"], name: "index_stock_transfers_on_destination_location_id"
    t.index ["shop_id", "number"], name: "index_stock_transfers_on_shop_id_and_number", unique: true
    t.index ["shop_id"], name: "index_stock_transfers_on_shop_id"
    t.index ["source_location_id"], name: "index_stock_transfers_on_source_location_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.datetime "email_verification_sent_at"
    t.string "email_verification_token"
    t.datetime "email_verified_at"
    t.string "name"
    t.string "password_digest", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["email_verification_token"], name: "index_users_on_email_verification_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "business_legal_profiles", "accounts"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "shops"
  add_foreign_key "categories", "shops"
  add_foreign_key "inventory_count_items", "inventory_counts"
  add_foreign_key "inventory_count_items", "products"
  add_foreign_key "inventory_counts", "locations"
  add_foreign_key "inventory_counts", "shops"
  add_foreign_key "inventory_levels", "locations"
  add_foreign_key "inventory_levels", "products"
  add_foreign_key "inventory_movements", "locations"
  add_foreign_key "inventory_movements", "products"
  add_foreign_key "locations", "shops"
  add_foreign_key "member_invitations", "accounts"
  add_foreign_key "member_invitations", "users", column: "invited_by_id"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "shops"
  add_foreign_key "payment_provider_accounts", "accounts"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "shops"
  add_foreign_key "sessions", "users"
  add_foreign_key "shops", "accounts"
  add_foreign_key "stock_transfer_items", "products"
  add_foreign_key "stock_transfer_items", "stock_transfers"
  add_foreign_key "stock_transfers", "locations", column: "destination_location_id"
  add_foreign_key "stock_transfers", "locations", column: "source_location_id"
  add_foreign_key "stock_transfers", "shops"
end
