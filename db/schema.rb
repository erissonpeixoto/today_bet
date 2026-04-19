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

ActiveRecord::Schema[8.1].define(version: 2026_04_18_191648) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.bigint "tip_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["tip_id"], name: "index_comments_on_tip_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "football_clubs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "logo_url"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_football_clubs_on_name", unique: true
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "away_club_id"
    t.datetime "created_at", null: false
    t.bigint "home_club_id"
    t.string "league", null: false
    t.datetime "match_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["away_club_id"], name: "index_matches_on_away_club_id"
    t.index ["home_club_id"], name: "index_matches_on_home_club_id"
    t.index ["match_date"], name: "index_matches_on_match_date"
    t.index ["status"], name: "index_matches_on_status"
  end

  create_table "tips", force: :cascade do |t|
    t.integer "comments_count", default: 0, null: false
    t.integer "confidence", default: 0, null: false
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.text "justification", null: false
    t.integer "market", null: false
    t.bigint "match_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "votes_agree_count", default: 0, null: false
    t.integer "votes_disagree_count", default: 0, null: false
    t.integer "votes_hot_count", default: 0, null: false
    t.index ["match_id", "comments_count"], name: "index_tips_on_match_id_and_comments_count"
    t.index ["match_id", "confidence"], name: "index_tips_on_match_id_and_confidence"
    t.index ["match_id", "votes_agree_count"], name: "index_tips_on_match_id_and_votes_agree_count"
    t.index ["match_id", "votes_hot_count"], name: "index_tips_on_match_id_and_votes_hot_count"
    t.index ["match_id"], name: "index_tips_on_match_id"
    t.index ["user_id", "match_id", "market"], name: "index_tips_on_user_id_and_match_id_and_market", unique: true
    t.index ["user_id"], name: "index_tips_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tip_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "vote_type", null: false
    t.index ["tip_id"], name: "index_votes_on_tip_id"
    t.index ["user_id", "tip_id", "vote_type"], name: "index_votes_on_user_id_and_tip_id_and_vote_type", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "comments", "tips"
  add_foreign_key "comments", "users"
  add_foreign_key "matches", "football_clubs", column: "away_club_id"
  add_foreign_key "matches", "football_clubs", column: "home_club_id"
  add_foreign_key "tips", "matches"
  add_foreign_key "tips", "users"
  add_foreign_key "votes", "tips"
  add_foreign_key "votes", "users"
end
