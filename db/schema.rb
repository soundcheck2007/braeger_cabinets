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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131106040736) do

  create_table "job_details", :force => true do |t|
    t.integer  "job_id"
    t.integer  "door_no"
    t.integer  "door_qty"
    t.string   "door_size"
    t.string   "door_style"
    t.string   "style_rail_info"
    t.string   "panel_info"
    t.string   "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "job_headers", :force => true do |t|
    t.string   "job"
    t.string   "wood_type"
    t.string   "inside_edge"
    t.string   "outside_edge"
    t.string   "panel_profile"
    t.date     "date_due"
    t.string   "drawer_type"
    t.string   "bottom_type"
    t.string   "bottom_notes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
