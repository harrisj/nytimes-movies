module Nytimes
	module Movies
		
		##
		# Represents a link to a multimedia asset from the New York Times. Invariably these are images or thumbnails, but it could also be expanded to
		# include movies or sound. The following attributes are part of the link. FIXME
		class MultimediaLink
			attr_reader :media_type, :url, :height, :width, :credit
			private_class_method :new
			
			def initialize(hash={})
				hash.each_pair do |k,v|
					instance_variable_set("@#{k}", v)
				end
			end
			
			##
			# Create a MultimediaLink object from a hash snippet returned from the API. You should never need to call this.
			def self.create_from_api(hash={})
				return nil if hash.nil? || hash.empty?
				
				if hash.key? 'resource'
					hash = hash['resource']
				end
				
				new(:media_type => hash['type'], :url => hash['src'], :height => hash['height'], :width => hash['width'], :credit => hash['credit'])
			end
		end
	end
end
