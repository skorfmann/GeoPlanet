namespace :geoplanet do
  namespace :ancestry do
    task :build => :environment do
     GeoplanetPlace.build_ancestry_from_parent_ids!
    end
  end

  require 'net/http'
  require 'crack'

  task :continents => :environment do
    [24865670, 24865671, 24865672, 24865673, 24865675, 28289421, 55949070].each do |woeid_continent|
      url = "http://where.yahooapis.com/v1/place/#{woeid_continent}/children;count=0?select=long&format=json&lang=de-DE&appid=yriO3VLV34FFnugEQiyGOPxdYv34qVysSj18QREiX5OCucPPM4fv9Kxk1H3yp2SJ"
      response = Net::HTTP.get_response(URI.parse(url)).body.to_s
      json = Crack::JSON.parse(response)
      json['places']['place'].each do |place|
        if country = GeoplanetPlace.find(:first, :conditions => {:woeid => place['woeid'], :parent_woeid => 1 })
          country.parent_woeid = woeid_continent
          country.save
        end
      end
    end
  end
end