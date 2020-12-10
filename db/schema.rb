# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_08_074039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batters", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "team"
    t.string "batting_average"
    t.integer "home_run"
    t.integer "runs_batted_in"
    t.integer "stolen_base"
    t.string "on_base_percentage"
    t.string "on_base_plus_slugging"
    t.integer "walks"
    t.integer "hit_by_pitch"
    t.string "scoring_position_batting_average"
    t.integer "strikeout"
    t.integer "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
  end

  create_table "favorite_batters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "batter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batter_id"], name: "index_favorite_batters_on_batter_id"
    t.index ["user_id"], name: "index_favorite_batters_on_user_id"
  end

  create_table "favorite_pitchers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pitcher_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pitcher_id"], name: "index_favorite_pitchers_on_pitcher_id"
    t.index ["user_id"], name: "index_favorite_pitchers_on_user_id"
  end

  create_table "pitchers", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "team"
    t.float "earned_run_average"
    t.integer "win"
    t.integer "lose"
    t.integer "strikeout"
    t.string "innings_pitched"
    t.integer "pitched"
    t.integer "number_of_save"
    t.integer "hold_point"
    t.float "strikeouts_per_nine_innings"
    t.float "strikeout_to_walk_ratio"
    t.float "walks_and_hits_per_innings_pitched"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorite_batters", "batters"
  add_foreign_key "favorite_batters", "users"
  add_foreign_key "favorite_pitchers", "pitchers"
  add_foreign_key "favorite_pitchers", "users"
end
