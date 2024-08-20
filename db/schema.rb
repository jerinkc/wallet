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

ActiveRecord::Schema[7.0].define(version: 2024_08_20_221101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loan_account_edit_histories", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2
    t.decimal "interest", precision: 5, scale: 2
    t.text "comment"
    t.bigint "editor_id"
    t.bigint "loan_account_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["editor_id"], name: "index_loan_account_edit_histories_on_editor_id"
    t.index ["loan_account_id"], name: "index_loan_account_edit_histories_on_loan_account_id"
  end

  create_table "loan_accounts", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2
    t.decimal "interest_percentage", precision: 5, scale: 2
    t.decimal "total_amount", precision: 12, scale: 2
    t.bigint "borrower_id", null: false
    t.bigint "editor_id"
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_id"], name: "index_loan_accounts_on_borrower_id"
    t.index ["editor_id"], name: "index_loan_accounts_on_editor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "full_name"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallet_accounts", force: :cascade do |t|
    t.decimal "balance", precision: 15, scale: 2, default: "0.0", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallet_accounts_on_user_id"
  end

  add_foreign_key "loan_account_edit_histories", "loan_accounts"
  add_foreign_key "loan_account_edit_histories", "users", column: "editor_id"
  add_foreign_key "loan_accounts", "users", column: "borrower_id"
  add_foreign_key "loan_accounts", "users", column: "editor_id"
  add_foreign_key "wallet_accounts", "users"
end
