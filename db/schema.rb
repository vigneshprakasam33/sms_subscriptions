# encoding: UTF-8

ActiveRecord::Schema.define(version: 20150224081021) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "subscription_id"
    t.datetime "execution_time"
    t.integer  "delayed_job_id"
    t.string   "status"
    t.string   "message"
    t.string   "recipient_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "payment_method"
    t.string   "price"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "order_id"
    t.text     "subscription_message"
    t.integer  "message_id"
    t.integer  "duration"
    t.string   "delivery_time"
    t.boolean  "gift"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "messages_count",       default: 0
    t.string   "status",               default: "active"
    t.boolean  "mute",                 default: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "phone"
    t.string   "password"
    t.string   "email"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "gift",       default: false
    t.uuid     "uuid"
    t.boolean  "is_admin",   default: false
  end

end
