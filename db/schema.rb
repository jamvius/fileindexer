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

ActiveRecord::Schema.define(:version => 20120308085534) do

  create_table "devices", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "uuid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "indexed_directories", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.integer  "parent_id"
    t.integer  "device_id"
    t.boolean  "symboliclink",             :default => false
    t.boolean  "indexable",                :default => true
    t.boolean  "sortable",                 :default => false
    t.boolean  "recursive",                :default => true
    t.boolean  "indexed",                  :default => false
    t.boolean  "analyzed",                 :default => false
    t.boolean  "deleted",                  :default => false
    t.integer  "numfiles",                 :default => 0
    t.integer  "numdirectories",           :default => 0
    t.integer  "size",                     :default => 0
    t.integer  "recursive_size",           :default => 0
    t.boolean  "recursive_indexed",        :default => false
    t.boolean  "recursive_analyzed",       :default => false
    t.integer  "recursive_numfiles",       :default => 0
    t.integer  "recursive_numdirectories", :default => 0
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "indexed_directories", ["device_id"], :name => "index_indexed_directories_on_device_id"
  add_index "indexed_directories", ["parent_id"], :name => "index_indexed_directories_on_parent_id"

  create_table "indexed_files", :force => true do |t|
    t.string   "name"
    t.integer  "size",         :default => -1
    t.string   "md5"
    t.integer  "parent_id"
    t.boolean  "symboliclink", :default => false
    t.boolean  "deleted",      :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "indexed_files", ["parent_id"], :name => "index_indexed_files_on_parent_id"

  create_table "indexer_tasks", :force => true do |t|
    t.string   "name"
    t.boolean  "recursive",            :default => false
    t.boolean  "overwrite",            :default => false
    t.integer  "device_id"
    t.integer  "indexed_directory_id"
    t.integer  "status_task_id",       :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "indexer_tasks", ["device_id"], :name => "index_indexer_tasks_on_device_id"
  add_index "indexer_tasks", ["indexed_directory_id"], :name => "index_indexer_tasks_on_indexed_directory_id"

  create_table "status_tasks", :force => true do |t|
    t.string "name"
  end

end
