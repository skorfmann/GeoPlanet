class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :geoplanet_aliases, :name
    add_index :geoplanet_aliases, :language_code
    add_index :geoplanet_aliases, [:language_code, :name]
    add_index :geoplanet_places, :name
    add_index :geoplanet_places, :language
  end

  def self.down
    remove_index :geoplanet_aliases, :name
    remove_index :geoplanet_aliases, :language_code
    remove_index :geoplanet_aliases, [:language_code, :name]
    remove_index :geoplanet_places, :name
    remove_index :geoplanet_places, :language
  end
end
