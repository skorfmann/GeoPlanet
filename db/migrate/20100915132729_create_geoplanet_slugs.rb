class CreateGeoplanetSlugs < ActiveRecord::Migration
  def self.up
    create_table :geoplanet_slugs, :force => true do |t|
      t.integer :woeid, :limit => 8
      t.string :language_code
      t.string :url
      t.timestamps
    end
    add_index :geoplanet_slugs, :woeid
    add_index :geoplanet_slugs, :url
  end

  def self.down
    drop_table :geoplanet_slugs
  end
end
