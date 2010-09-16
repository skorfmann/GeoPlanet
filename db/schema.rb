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

ActiveRecord::Schema.define(:version => 20100915135505) do

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

  add_index "geoplanet_aliases", ["language_code", "name"], :name => "index_geoplanet_aliases_on_language_code_and_name"
  add_index "geoplanet_aliases", ["language_code"], :name => "index_geoplanet_aliases_on_language_code"
  add_index "geoplanet_aliases", ["name"], :name => "index_geoplanet_aliases_on_name"
  add_index "geoplanet_aliases", ["woeid"], :name => "index_geoplanet_aliases_on_woeid"

  create_table "geoplanet_places", :force => true do |t|
    t.integer "woeid",                 :limit => 8
    t.integer "parent_woeid",          :limit => 8
    t.string  "country_code"
    t.string  "name"
    t.string  "language"
    t.string  "place_type"
    t.string  "ancestry"
    t.integer "locations_count",                    :default => 0
    t.integer "hotels_count",                       :default => 0
    t.integer "recommendations_count",              :default => 0
  end

  add_index "geoplanet_places", ["ancestry"], :name => "index_geoplanet_places_on_ancestry"
  add_index "geoplanet_places", ["hotels_count"], :name => "index_geoplanet_places_on_hotels_count"
  add_index "geoplanet_places", ["language"], :name => "index_geoplanet_places_on_language"
  add_index "geoplanet_places", ["locations_count"], :name => "index_geoplanet_places_on_locations_count"
  add_index "geoplanet_places", ["name"], :name => "index_geoplanet_places_on_name"
  add_index "geoplanet_places", ["parent_woeid"], :name => "index_geoplanet_places_on_parent_woeid"
  add_index "geoplanet_places", ["place_type", "name"], :name => "index_geoplanet_places_on_place_type_and_name"
  add_index "geoplanet_places", ["place_type"], :name => "index_geoplanet_places_on_place_type"
  add_index "geoplanet_places", ["recommendations_count"], :name => "index_geoplanet_places_on_recommendations_count"
  add_index "geoplanet_places", ["woeid"], :name => "index_geoplanet_places_on_woeid", :unique => true

  create_table "geoplanet_slugs", :force => true do |t|
    t.integer  "woeid",         :limit => 8
    t.string   "language_code"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geoplanet_slugs", ["url"], :name => "index_geoplanet_slugs_on_url"
  add_index "geoplanet_slugs", ["woeid"], :name => "index_geoplanet_slugs_on_woeid"

end
