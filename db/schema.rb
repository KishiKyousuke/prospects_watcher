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

ActiveRecord::Schema.define(version: 2020_10_22_062923) do

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
    t.integer "save"
    t.integer "hold_point"
    t.float "strikeouts_per_nine_innings"
    t.float "strikeout_to_walk_ratio"
    t.float "walks_and_hits_per_innings_pitched"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
