namespace :geoplanet do
  task :localize => :environment do
    updater = lambda {|n, w| GeoplanetPlace.update_all(["geoplanet_places.name = ?", n], ["geoplanet_places.woeid = ?", w]) unless n.blank? }
    puts "getting german places"
    german_places = GeoplanetPlace.language(:GER)
    puts "#{german_places.length} elements"
    puts "getting german aliases"
    german_locales = GeoplanetAlias.grouped_by_woeid.language(:GER)
    puts "#{german_locales.length} elments"
    puts "selecting targets"
    targets = german_locales.select { |gl| gl.count.to_i > 1 }.map(&:woeid) - german_places.map(&:woeid)
    puts "#{targets.length} elements"
    puts "calliing api"
    targets.each_with_index do |woeid, index|
      url = "http://where.yahooapis.com/v1/place/#{woeid}?select=long&format=json&lang=de-DE&appid=yriO3VLV34FFnugEQiyGOPxdYv34qVysSj18QREiX5OCucPPM4fv9Kxk1H3yp2SJ"
      response = Net::HTTP.get_response(URI.parse(url)).body.to_s
      json = Crack::JSON.parse(response)
      name = json['place']['name']
      puts [index, name] * ", "
      updater.call(name, woeid)
    end
    puts "-------------------------------- local ------- "
    puts "selecting targets"
    puts "#{german_locales.length} elements"
    targets = german_locales.select {|gl| gl.count.to_i == 1}.map(&:woeid)  - german_places.map(&:woeid)
    targets1 = german_locales.select {|gl| targets.include?(gl.woeid) }
    puts "#{targets.length} elements"
    targets1.each_with_index do |target, index|
      puts [index, target.woeid, target.name] * ","
      updater.call(target.name, target.woeid)
    end
  end

  task :retry => :environment do
    updater = lambda {|n, w| GeoplanetPlace.update_all(["geoplanet_places.name = ?", n], ["geoplanet_places.woeid = ?", w]) unless n.blank? }
    puts "getting german places"
    german_places = GeoplanetPlace.language(:GER)
    puts "#{german_places.length} elements"
    puts "getting german aliases"
    german_locales = GeoplanetAlias.grouped_by_woeid.language(:GER)
    puts "#{german_locales.length} elments"
    puts "selecting targets"
    puts "-------------------------------- local ------- "
    puts "selecting targets"
    puts "#{german_locales.length} elements"
    targets = german_locales.select {|gl| gl.count.to_i == 1}.map(&:woeid)  - german_places.map(&:woeid)
    targets1 = german_locales.select {|gl| targets.include?(gl.woeid) }
    puts "#{targets.length} elements"
    targets1.each_with_index do |target, index|
      url = "http://where.yahooapis.com/v1/place/#{target.woeid}?select=long&format=json&lang=de-DE&appid=yriO3VLV34FFnugEQiyGOPxdYv34qVysSj18QREiX5OCucPPM4fv9Kxk1H3yp2SJ"
      response = Net::HTTP.get_response(URI.parse(url)).body.to_s
      json = Crack::JSON.parse(response)
      name = json['place']['name']
      unless target.geoplanet_place.name == name
        puts [index, name] * ", "
        updater.call(name, target.woeid)
        if slug = GeoplanetSlug.find_by_woeid(target.woeid)
          slug.url = target.geoplanet_place.sluggable_path
          slug.save
        end
        path = target.geoplanet_place.path.map(&:woeid).join("/")
        descendants = GeoplanetPlace.find(:all, :conditions => ["(ancestry LIKE ? OR ancestry = ?) AND place_type IN (?)", (path + "/%"), path, %w(Country State Town)])
        puts "building #{descendants.length} new slugs"
        descendants.each do |descendant|
          slug = GeoplanetSlug.find_or_initialize_by_woeid_and_language_code(descendant.woeid, "GER")
          slug.url = descendant.sluggable_path
          slug.save
        end
      end
    end
  end
end
