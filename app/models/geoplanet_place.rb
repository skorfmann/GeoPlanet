class GeoplanetPlace < ActiveRecord::Base

  has_ancestry

  set_primary_key 'woeid'


  has_many :aliases, :class_name => 'GeoplanetAlias', :foreign_key => 'woeid'
  has_many :adjacencies, :class_name => 'GeoplanetAdjacency', :foreign_key => 'woeid'
  has_many :adjacent_places, :through => :adjacencies
  has_many :slugs, :class_name => "GeoplanetSlug", :foreign_key => 'woeid'

  named_scope :language, lambda {|code| {:conditions => {:language => code.to_s}}}
  named_scope :select, lambda {|*columns| {:select => columns.map {|column| "geoplanet_places.#{column.to_s}"}.join(", ") } }

  %w(continent country state town).each do |place_type|
    instance_eval do
      named_scope place_type.pluralize.to_sym, :conditions => {:place_type => place_type.capitalize }
    end
  end

  def self.build_ancestry_from_parent_ids! parent_id = nil, ancestry = nil
    parent_id = parent_id || 0
    self.base_class.all(:conditions => {:parent_woeid => parent_id}).each do |node|
      node.without_ancestry_callbacks do
        node.update_attribute ancestry_column, ancestry
      end
      build_ancestry_from_parent_ids! node.id, if ancestry.nil? then "#{node.id}" else "#{ancestry}/#{node.id}" end
    end
  end


  def sluggable_path
    slug_path = GeoplanetPlace.find(:all,
                        :conditions => {:woeid => ancestry.split("/").map(&:to_i),
                                        :place_type => %w(Country State Town)},
                        :order => "(case when ancestry is null then 0 else 1 end), ancestry")
    slug_path.push(self)
    slug_path.map! {|sp| sp.name.gsub("\s", "+") }
    slug_path.join("/")
  end


end
