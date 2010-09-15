class AddPlaceTypeIndexToGeoplanetPlaces < ActiveRecord::Migration
  def self.up
    add_index :geoplanet_places, :place_type
    add_index :geoplanet_places, [:place_type, :name]
  end

  def self.down
    remove_index :geoplanet_places, :place_type
    remove_index :geoplanet_places, [:place_type, :name]
  end
end
