class GeoplanetAlias < ActiveRecord::Base

  belongs_to :geoplanet_place, :foreign_key => 'woeid', :primary_key => 'woeid'

end
