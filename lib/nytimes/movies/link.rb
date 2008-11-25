module Nytimes
	module Movies
		class Link
			attr_reader :link_type, :url, :suggested_text
			
			def initialize(hash={})
				@url = hash[:url]
				@link_type = hash[:link_type]
				@suggested_text = hash[:suggested_text]
			end
			
			def self.create_from_api(hash={})
				Link.new :url => hash['url'], :link_type => hash['type'], :suggested_text => hash['suggested_link_text']
			end
		end
	end
end