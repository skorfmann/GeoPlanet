namespace :geoplanet do

  DATA_PATH = File.join(Rails.root, 'data', 'geoplanet_data_7.5.2')

  namespace :import do

    task :all => [:places, :aliases, :adjacencies]

    task :places => :environment do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE geoplanet_places")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_places DISABLE KEYS")
      ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE '#{DATA_PATH}/geoplanet_places_7.5.2.tsv' REPLACE INTO TABLE geoplanet_places
      FIELDS TERMINATED BY '\\t' OPTIONALLY ENCLOSED BY '\"'
      IGNORE 1 LINES
      (woeid, country_code, name, language, place_type, parent_woeid);")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_places ENABLE KEYS")
    end

    task :aliases => :environment do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE geoplanet_aliases")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_aliases DISABLE KEYS")
      ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE '#{DATA_PATH}/geoplanet_aliases_7.5.2.tsv' REPLACE INTO TABLE geoplanet_aliases
      FIELDS TERMINATED BY '\\t' OPTIONALLY ENCLOSED BY '\"'
      IGNORE 1 LINES
      (woeid, name, name_type, language_code);")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_aliases ENABLE KEYS")
    end

    task :adjacencies => :environment do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE geoplanet_adjacencies")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_adjacencies DISABLE KEYS")
      ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE '#{DATA_PATH}/geoplanet_adjacencies_7.5.2.tsv' REPLACE INTO TABLE geoplanet_adjacencies
      FIELDS TERMINATED BY '\\t' OPTIONALLY ENCLOSED BY '\"'
      IGNORE 1 LINES
      (woeid, iso_code, neighbour_woeid, neighbour_iso_code);")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_adjacencies ENABLE KEYS")
    end
  end

end