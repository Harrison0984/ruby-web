# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150721152640) do

  create_table "gridconfigs", force: :cascade do |t|
    t.integer  "gridtype"
    t.float    "probability"
    t.float    "mulbability"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "grids", force: :cascade do |t|
    t.integer  "x1"
    t.integer  "x2"
    t.integer  "x3"
    t.integer  "y1"
    t.integer  "y2"
    t.integer  "y3"
    t.integer  "z1"
    t.integer  "z2"
    t.integer  "z3"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "gameid"
  end

  create_table "loginlogs", force: :cascade do |t|
    t.string   "username"
    t.integer  "action"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operlogs", force: :cascade do |t|
    t.string   "maname"
    t.string   "username"
    t.integer  "coin"
    t.string   "action"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key"

  create_table "tasklogs", force: :cascade do |t|
    t.integer  "totalbar"
    t.integer  "currentbar"
    t.integer  "errorbar"
    t.integer  "totalcoin"
    t.integer  "prizecoin"
    t.datetime "runtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "taskdate"
    t.datetime "nexttime"
    t.string   "nextgameid"
  end

  create_table "tracelogs", force: :cascade do |t|
    t.integer  "gametype"
    t.integer  "pos"
    t.integer  "coin"
    t.integer  "status"
    t.float    "mulbability"
    t.datetime "time"
    t.integer  "userid"
    t.string   "useraccount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "maintype"
    t.string   "gameid"
    t.string   "nextgameid"
    t.string   "flag"
  end

  create_table "users", force: :cascade do |t|
    t.string   "account"
    t.string   "password"
    t.string   "nickname"
    t.integer  "coin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "level"
    t.integer  "action"
    t.integer  "lowerlimit"
    t.integer  "upperlimit"
    t.integer  "todaycoin"
    t.integer  "everylimit"
    t.string   "regionname"
  end

end
