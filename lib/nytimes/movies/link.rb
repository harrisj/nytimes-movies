module Nytimes
	module Movies
		
		##
		# Represents a link returned from the Reviews API. Each link has a URL, suggested text, and a link_type which gives you some idea of what the remote
		# target of the link is. Possible link types include:
		# FIXME
		class Link
			attr_reader :link_type, :url, :suggested_text
			
			def initialize(hash={})
				@url = hash[:url]
				@link_type = hash[:link_type]
				@suggested_text = hash[:suggested_text]
			end
			
			##
			# Create a Link object from a hash snippet returned from the API. You should never need to call this.
			def self.create_from_api(hash={})
				Link.new :url => hash['url'], :link_type => hash['type'], :suggested_text => hash['suggested_link_text']
			end
		end
	end
end