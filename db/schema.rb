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

ActiveRecord::Schema.define(version: 20151123130946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configurables", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurables", ["name"], name: "index_configurables_on_name", using: :btree

  create_table "follows", force: true do |t|
    t.integer "a_id", limit: 8
    t.integer "b_id", limit: 8
  end

  add_index "follows", ["a_id", "b_id"], name: "index_follows_on_a_id_and_b_id", unique: true, using: :btree
  add_index "follows", ["b_id"], name: "index_follows_on_b_id", using: :btree

  create_table "liked_tweets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tweet_id",        limit: 8
    t.integer  "twitter_user_id", limit: 8
    t.integer  "user_id"
    t.boolean  "removed"
    t.boolean  "followed_back"
    t.string   "tweet"
    t.string   "phrase"
    t.datetime "tweeted_at"
  end

  create_table "users", id: false, force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind"
    t.string   "user_token"
    t.string   "user_secret"
    t.string   "app_token"
    t.string   "app_secret"
    t.string   "stripe_id"
    t.string   "email"
    t.string   "screen_name"
    t.integer  "id",          limit: 8
  end

end
