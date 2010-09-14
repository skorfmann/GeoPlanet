namespace :geoplanet do
  namespace :ancestry do
    task :build => :environment do
     GeoplanetPlace.build_ancestry_from_parent_ids!
    end
  end
end