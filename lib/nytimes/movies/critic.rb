module Nytimes
	module Movies
		class Critic < Base
			attr_reader :display_name, :sort_name, :status, :bio, :seo_name, :photo
			
			def initialize(params={})
				params.each_pair do |k,v|
					instance_variable_set("@#{k}", v)
				end
			end
			
			def self.create_from_api(params={})
				self.new :display_name => params['display_name'],
								 :sort_name => params['sort_name'],
								 :status => params['status'],
								 :bio => params['bio'],
								 :seo_name => params['seo_name'],
								 :photo => MultimediaLink.create_from_api(params['multimedia'])
			end
			
			def self.find_by_type(type)
				key = case type
				when :full_time
					'full-time'
				when :part_time
					'part-time'
				when :all
					'all'
				else
					raise ArgumentError, "Type can be :full_time, :part_time, or :all"
				end
				
				reply = invoke("critics/#{key}")
				results = reply['results']
				results.map {|r| self.create_from_api(r)}
			end
			
			def self.escape_critic_name(name)
				return name if name =~ /^[a-z\-]+$/  # might be escaped already
				name.downcase.gsub(/[^a-z\s]/, ' ').gsub(/\s+/, '-')
			end
			
			def self.find_by_name(name)
				name = escape_critic_name(name)
				reply = invoke("critics/#{name}")
				return nil if reply.nil? || reply['results'].nil?
				results = reply['results']
				critics = results.map {|r| self.create_from_api(r)}
				return critics.first if critics.length == 1
				critics
			end
		end
	end
end
