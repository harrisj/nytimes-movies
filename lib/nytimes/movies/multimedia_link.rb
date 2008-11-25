module Nytimes
	module Movies
		class MultimediaLink
			attr_reader :media_type, :url, :height, :width, :credit
			private_class_method :new
			
			def initialize(hash={})
				hash.each_pair do |k,v|
					instance_variable_set("@#{k}", v)
				end
			end
			
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
