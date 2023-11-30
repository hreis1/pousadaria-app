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

ActiveRecord::Schema[7.0].define(version: 2023_11_30_205819) do
  create_table "custom_prices", force: :cascade do |t|
    t.integer "room_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_custom_prices_on_room_id"
  end

  create_table "inns", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.string "trade_name"
    t.string "corporate_name"
    t.string "cnpj"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "address_number"
    t.string "neighborhood"
    t.string "state"
    t.string "city"
    t.string "cep"
    t.string "description"
    t.string "payment_methods"
    t.boolean "pets_allowed"
    t.string "polices"
    t.time "checkin_time"
    t.time "checkout_time"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_inns_on_owner_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "rates", force: :cascade do |t|
    t.integer "rating"
    t.text "review"
    t.text "response"
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_rates_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.date "checkin"
    t.date "checkout"
    t.integer "number_of_guests"
    t.integer "status", default: 0
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "code"
    t.datetime "checkin_at"
    t.datetime "checkout_at"
    t.string "payment_method"
    t.string "amount_paid"
    t.string "integer"
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "inn_id", null: false
    t.string "name"
    t.string "description"
    t.integer "dimension"
    t.integer "max_occupancy", default: 1
    t.integer "daily_rate"
    t.boolean "has_bathroom", default: false
    t.boolean "has_balcony", default: false
    t.boolean "has_air_conditioning", default: false
    t.boolean "has_tv", default: false
    t.boolean "has_closet", default: false
    t.boolean "has_safe", default: false
    t.boolean "is_accessible", default: false
    t.boolean "is_available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "cpf"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "custom_prices", "rooms"
  add_foreign_key "inns", "owners"
  add_foreign_key "rates", "reservations"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "reservations", "users"
  add_foreign_key "rooms", "inns"
end
