class BootstrappingGeoplanetTables < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table "geoplanet_adjacencies"
    drop_table "geoplanet_aliases"
    drop_table "geoplanet_places"
  end

end
