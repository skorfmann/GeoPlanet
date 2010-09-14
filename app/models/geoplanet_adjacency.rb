class GeoplanetAdjacency < ActiveRecord::Base

  belongs_to :place, :class_name => 'GeoplanetPlace', :foreign_key => 'woeid', :primary_key => 'woeid'
  belongs_to :adjacent_place, :class_name => 'GeoplanetPlace', :foreign_key => 'neighbour_woeid', :primary_key => 'woeid'

end