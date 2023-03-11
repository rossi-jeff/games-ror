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

ActiveRecord::Schema.define(version: 2023_03_09_215843) do

  create_table "code_breaker_codes", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Color"
    t.bigint "code_breaker_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_breaker_id"], name: "index_code_breaker_codes_on_code_breaker_id"
  end

  create_table "code_breaker_guess_colors", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Color"
    t.bigint "code_breaker_guess_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_breaker_guess_id"], name: "index_code_breaker_guess_colors_on_code_breaker_guess_id"
  end

  create_table "code_breaker_guess_keys", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Key"
    t.bigint "code_breaker_guess_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_breaker_guess_id"], name: "index_code_breaker_guess_keys_on_code_breaker_guess_id"
  end

  create_table "code_breaker_guesses", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "code_breaker_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_breaker_id"], name: "index_code_breaker_guesses_on_code_breaker_id"
  end

  create_table "code_breakers", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Status", default: 1
    t.integer "Columns"
    t.integer "Colors"
    t.integer "Score", default: 0
    t.string "Available", limit: 75
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_code_breakers_on_user_id"
  end

  create_table "concentrations", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Status", default: 1
    t.integer "Moves", default: 0
    t.integer "Matched", default: 0
    t.integer "Elapsed", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_concentrations_on_user_id"
  end

  create_table "free_cells", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Status", default: 1
    t.integer "Moves", default: 0
    t.integer "Elapsed", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_free_cells_on_user_id"
  end

  create_table "guess_word_guess_ratings", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Rating"
    t.bigint "guess_word_guess_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guess_word_guess_id"], name: "index_guess_word_guess_ratings_on_guess_word_guess_id"
  end

  create_table "guess_word_guesses", charset: "utf8mb4", force: :cascade do |t|
    t.string "Guess", limit: 30
    t.bigint "guess_word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guess_word_id"], name: "index_guess_word_guesses_on_guess_word_id"
  end

  create_table "guess_words", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Status", default: 1
    t.integer "Score", default: 0
    t.bigint "user_id"
    t.bigint "word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_guess_words_on_user_id"
    t.index ["word_id"], name: "index_guess_words_on_word_id"
  end

  create_table "hang_men", charset: "utf8mb4", force: :cascade do |t|
    t.string "Correct", limit: 75, default: ""
    t.string "Wrong", limit: 25, default: ""
    t.integer "Status", default: 1
    t.integer "Score", default: 0
    t.bigint "user_id"
    t.bigint "word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_hang_men_on_user_id"
    t.index ["word_id"], name: "index_hang_men_on_word_id"
  end

  create_table "klondikes", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Status", default: 1
    t.integer "Moves", default: 0
    t.integer "Elapsed", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_klondikes_on_user_id"
  end

  create_table "sea_battle_ship_grid_points", charset: "utf8mb4", force: :cascade do |t|
    t.string "Horizontal", limit: 1
    t.integer "Vertical"
    t.bigint "sea_battle_ship_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sea_battle_ship_id"], name: "index_sea_battle_ship_grid_points_on_sea_battle_ship_id"
  end

  create_table "sea_battle_ship_hits", charset: "utf8mb4", force: :cascade do |t|
    t.string "Horizontal", limit: 1
    t.integer "Vertical"
    t.bigint "sea_battle_ship_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sea_battle_ship_id"], name: "index_sea_battle_ship_hits_on_sea_battle_ship_id"
  end

  create_table "sea_battle_ships", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Type"
    t.integer "Navy"
    t.integer "Size"
    t.boolean "Sunk", default: false
    t.bigint "sea_battle_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sea_battle_id"], name: "index_sea_battle_ships_on_sea_battle_id"
  end

  create_table "sea_battle_turns", charset: "utf8mb4", force: :cascade do |t|
    t.integer "ShipType"
    t.integer "Navy"
    t.integer "Target"
    t.string "Horizontal", limit: 1
    t.integer "Vertical"
    t.bigint "sea_battle_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sea_battle_id"], name: "index_sea_battle_turns_on_sea_battle_id"
  end

  create_table "sea_battles", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Axis", default: 8
    t.integer "Status", default: 1
    t.integer "Score", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sea_battles_on_user_id"
  end

  create_table "ten_grand_scores", charset: "utf8mb4", force: :cascade do |t|
    t.string "Dice", limit: 20
    t.integer "Category", default: 0
    t.integer "Score", default: 0
    t.bigint "ten_grand_turn_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ten_grand_turn_id"], name: "index_ten_grand_scores_on_ten_grand_turn_id"
  end

  create_table "ten_grand_turns", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Score", default: 0
    t.bigint "ten_grand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ten_grand_id"], name: "index_ten_grand_turns_on_ten_grand_id"
  end

  create_table "ten_grands", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Status", default: 1
    t.integer "Score", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_ten_grands_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "UserName", limit: 30
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "words", charset: "utf8mb4", force: :cascade do |t|
    t.string "Word", limit: 30
    t.integer "Length"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "yacht_turns", charset: "utf8mb4", force: :cascade do |t|
    t.string "RollOne", limit: 20, default: ""
    t.string "RollTwo", limit: 20, default: ""
    t.string "RollThree", limit: 20, default: ""
    t.integer "Category"
    t.integer "Score", default: 0
    t.bigint "yacht_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["yacht_id"], name: "index_yacht_turns_on_yacht_id"
  end

  create_table "yachts", charset: "utf8mb4", force: :cascade do |t|
    t.integer "Total", default: 0
    t.integer "NumTurns", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_yachts_on_user_id"
  end

  add_foreign_key "code_breaker_codes", "code_breakers"
  add_foreign_key "code_breaker_guess_colors", "code_breaker_guesses"
  add_foreign_key "code_breaker_guess_keys", "code_breaker_guesses"
  add_foreign_key "code_breaker_guesses", "code_breakers"
  add_foreign_key "code_breakers", "users"
  add_foreign_key "concentrations", "users"
  add_foreign_key "free_cells", "users"
  add_foreign_key "guess_word_guess_ratings", "guess_word_guesses"
  add_foreign_key "guess_word_guesses", "guess_words"
  add_foreign_key "guess_words", "users"
  add_foreign_key "guess_words", "words"
  add_foreign_key "hang_men", "users"
  add_foreign_key "hang_men", "words"
  add_foreign_key "klondikes", "users"
  add_foreign_key "sea_battle_ship_grid_points", "sea_battle_ships"
  add_foreign_key "sea_battle_ship_hits", "sea_battle_ships"
  add_foreign_key "sea_battle_ships", "sea_battles"
  add_foreign_key "sea_battle_turns", "sea_battles"
  add_foreign_key "sea_battles", "users"
  add_foreign_key "ten_grand_scores", "ten_grand_turns"
  add_foreign_key "ten_grand_turns", "ten_grands"
  add_foreign_key "ten_grands", "users"
  add_foreign_key "yacht_turns", "yachts"
  add_foreign_key "yachts", "users"
end
