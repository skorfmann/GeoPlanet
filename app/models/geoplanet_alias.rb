class GeoplanetAlias < ActiveRecord::Base

  belongs_to :geoplanet_place, :foreign_key => 'woeid', :primary_key => 'woeid'

  named_scope :language, lambda {|code| {:conditions => {:language_code => code.to_s}}}

  named_scope :grouped_by_woeid, {
            :select => "COUNT(*) as count, geoplanet_aliases.*",
            :group => "geoplanet_aliases.woeid, geoplanet_aliases.language_code"
    }

  named_scope :limit, lambda {|max| {:limit => max}}


end
