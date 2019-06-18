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

ActiveRecord::Schema.define(version: 2019_05_14_020725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entities", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "documentation"
    t.text "plural"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.integer "link_to"
    t.integer "link_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parameters", force: :cascade do |t|
    t.text "filename", null: false
    t.text "description"
    t.text "href"
    t.json "brackets"
    t.json "values"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "entity_id"
    t.text "name"
    t.text "plural"
    t.text "description"
    t.integer "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_roles_on_entity_id"
  end

  create_table "scenario_variables", force: :cascade do |t|
    t.bigint "scenario_id"
    t.bigint "variable_id"
    t.string "direction"
    t.index ["scenario_id", "variable_id", "direction"], name: "scenario_variables_key", unique: true
    t.index ["scenario_id"], name: "index_scenario_variables_on_scenario_id"
    t.index ["variable_id"], name: "index_scenario_variables_on_variable_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name", null: false
    t.json "inputs"
    t.json "outputs"
    t.string "period"
    t.integer "error_margin"
    t.string "namespace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "value_types", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "variable_translations", force: :cascade do |t|
    t.bigint "variable_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["locale"], name: "index_variable_translations_on_locale"
    t.index ["variable_id"], name: "index_variable_translations_on_variable_id"
  end

  create_table "variables", force: :cascade do |t|
    t.text "name", null: false
    t.text "description"
    t.text "href"
    t.json "spec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "namespace"
    t.bigint "value_type_id"
    t.bigint "entity_id"
    t.string "unit"
    t.string "references", default: [], array: true
    t.index ["entity_id"], name: "index_variables_on_entity_id"
    t.index ["value_type_id"], name: "index_variables_on_value_type_id"
  end

  add_foreign_key "scenario_variables", "scenarios"
  add_foreign_key "scenario_variables", "variables"
  add_foreign_key "variables", "entities"
  add_foreign_key "variables", "value_types"
end
