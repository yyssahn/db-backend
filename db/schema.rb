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

ActiveRecord::Schema.define(version: 20170729055413) do

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "address"
    t.string "city"
    t.string "storeid"
    t.string "storename"
    t.string "zipcode"
    t.string "productname"
    t.decimal "price", precision: 2
    t.decimal "thc", precision: 10
    t.decimal "thcvalue", precision: 10
    t.integer "numtimesseen", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
