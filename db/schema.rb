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

ActiveRecord::Schema.define(version: 2021_01_06_082058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batters", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "batting_average"
    t.string "home_run"
    t.string "runs_batted_in"
    t.string "stolen_base"
    t.string "on_base_percentage"
    t.string "on_base_plus_slugging"
    t.string "walks"
    t.string "hit_by_pitch"
    t.string "scoring_position_batting_average"
    t.string "strikeout"
    t.string "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.bigint "team_id"
    t.string "at_bat"
    t.string "hits"
    t.string "plate_appearance"
    t.index ["team_id"], name: "index_batters_on_team_id"
  end

  create_table "favorite_batters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "batter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batter_id"], name: "index_favorite_batters_on_batter_id"
    t.index ["user_id", "batter_id"], name: "index_favorite_batters_on_user_id_and_batter_id", unique: true
    t.index ["user_id"], name: "index_favorite_batters_on_user_id"
  end

  create_table "favorite_pitchers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pitcher_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pitcher_id"], name: "index_favorite_pitchers_on_pitcher_id"
    t.index ["user_id", "pitcher_id"], name: "index_favorite_pitchers_on_user_id_and_pitcher_id", unique: true
    t.index ["user_id"], name: "index_favorite_pitchers_on_user_id"
  end

  create_table "pitchers", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "earned_run_average"
    t.string "win"
    t.string "lose"
    t.string "strikeout"
    t.string "innings_pitched"
    t.string "pitched"
    t.string "number_of_save"
    t.string "hold_point"
    t.string "strikeouts_per_nine_innings"
    t.string "strikeout_to_walk_ratio"
    t.string "walks_and_hits_per_innings_pitched"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.bigint "team_id"
    t.index ["team_id"], name: "index_pitchers_on_team_id"
  end

  create_table "scraping_logs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "result"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "formal_name", null: false
    t.integer "ranking", null: false
    t.integer "league", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "url_id", null: false
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

  add_foreign_key "batters", "teams"
  add_foreign_key "favorite_batters", "batters"
  add_foreign_key "favorite_batters", "users"
  add_foreign_key "favorite_pitchers", "pitchers"
  add_foreign_key "favorite_pitchers", "users"
  add_foreign_key "pitchers", "teams"
end
