class GeoplanetSlug < ActiveRecord::Base

  belongs_to :geoplanet_place, :foreign_key => "woeid", :primary_key => "woeid"

  named_scope :grouped_by_slug, {
          :select => "COUNT(*) AS count, geoplanet_slugs.*",
          :group => "geoplanet_slugs.url",
          #:limit => 20000,
          :having => "count > 1",
          :order => "count DESC"
          }
end
