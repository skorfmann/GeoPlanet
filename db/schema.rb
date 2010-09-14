# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100914084033) do

  create_table "geoplanet_adjacencies", :force => true do |t|
    t.integer "woeid",              :limit => 8
    t.string  "iso_code"
    t.integer "neighbour_woeid",    :limit => 8
    t.string  "neighbour_iso_code"
  end

  add_index "geoplanet_adjacencies", ["woeid"], :name => "index_geoplanet_adjacencies_on_woeid"

  create_table "geoplanet_aliases", :force => true do |t|
    t.integer "woeid",         :limit => 8
    t.string  "name"
    t.string  "name_type"
    t.string  "language_code"
  end

  add_index "geoplanet_aliases", ["woeid"], :name => "index_geoplanet_aliases_on_woeid"

  create_table "geoplanet_places", :force => true do |t|
    t.integer "woeid",        :limit => 8
    t.integer "parent_woeid", :limit => 8
    t.string  "country_code"
    t.string  "name"
    t.string  "language"
    t.string  "place_type"
    t.string  "ancestry"
  end

  add_index "geoplanet_places", ["ancestry"], :name => "index_geoplanet_places_on_ancestry"
  add_index "geoplanet_places", ["parent_woeid"], :name => "index_geoplanet_places_on_parent_woeid"
  add_index "geoplanet_places", ["woeid"], :name => "index_geoplanet_places_on_woeid", :unique => true

end
