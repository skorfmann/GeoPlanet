class AddPlaceTypeIndexToGeoplanetPlaces < ActiveRecord::Migration
  def self.up
    alter_table :geoplanet_places do |t|
      t.add_column :locations_count, :integer, :default => 0
      t.add_column :hotels_count, :integer, :default => 0
      t.add_column :recommendations_count, :integer, :default => 0
      t.add_index :locations_count
      t.add_index :hotels_count
      t.add_index :recommendations_count
      t.add_index :place_type
      t.add_index [:place_type, :name]
    end
    #add_index :geoplanet_places, :place_type
    #add_index :geoplanet_places, [:place_type, :name]
  end

  def self.down
    alter_table :geoplanet_places do |t|
      t.remove_column :locations_count
      t.remove_column :hotels_count
      t.remove_column :recommendations_count
      t.remove_index :locations_count
      t.remove_index :hotels_count
      t.remove_index :recommendations_count
      t.remove_index :place_type
      t.remove_index [:place_type, :name]
    end
    # remove_index :geoplanet_places, :place_type
    #remove_index :geoplanet_places, [:place_type, :name]
  end
end
