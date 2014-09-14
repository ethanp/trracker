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

ActiveRecord::Schema.define(version: 20140914051150) do

  create_table "categories", force: true do |t|
    t.string   "name",        null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id"

  create_table "intervals", force: true do |t|
    t.datetime "start",      null: false
    t.datetime "end",        null: false
    t.integer  "task_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "intervals", ["task_id"], name: "index_intervals_on_task_id"

  create_table "subtasks", force: true do |t|
    t.integer  "task_id",    null: false
    t.string   "name",       null: false
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subtasks", ["task_id"], name: "index_subtasks_on_task_id"

  create_table "tasks", force: true do |t|
    t.string   "name",        null: false
    t.boolean  "complete"
    t.datetime "duedate"
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",    null: false
    t.boolean  "turned_in"
  end

  add_index "tasks", ["category_id"], name: "index_tasks_on_category_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
