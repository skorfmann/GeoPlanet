namespace :geoplanet do

  task :generate_slugs => :environment do
    count = 1
    last = 0
    while places = GeoplanetPlace.find(:all, :conditions => ["woeid > ? AND place_type IN (?)", last, %w(Country State Town)], :order => "woeid ASC", :limit => 5000) do
      places.each do |place|
        slug = GeoplanetSlug.find_or_initialize_by_woeid_and_language_code(place.woeid, "GER")
        slug.url = place.sluggable_path
        slug.save
      end
      puts "processed #{count * 5000} items"
      last = places.last
      count += 1
      break unless last
    end
  end

end