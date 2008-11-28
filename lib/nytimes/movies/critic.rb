module Nytimes
	module Movies
		class Critic < Base
			attr_reader :display_name, :sort_name, :status, :bio, :seo_name, :photo
			
			def initialize(params={})
				params.each_pair do |k,v|
					instance_variable_set("@#{k}", v)
				end
			end
			
			##
			# Returns reviews made by the critic. Please refer to Review#find for other optional flags that can be applied.
			def reviews(params={})
				Review.find(params.merge :reviewer => seo_name)
			end
			
			def self.create_from_api(params={})
				self.new :display_name => params['display_name'],
								 :sort_name => params['sort_name'],
								 :status => params['status'],
								 :bio => params['bio'],
								 :seo_name => params['seo_name'],
								 :photo => MultimediaLink.create_from_api(params['multimedia'])
			end
			
			##
			# Returns a list of critics that match a given type. The following types are supported:
			# * <tt>:full_time</tt> - fulltime critics at the New York Times
			# * <tt>:part_time</tt> - part-time critics at the New York Times
			# * <tt>:all</tt> - all critics
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
			
			##
			# Escapes a critic's name to the SEO variation used for name searches. This is automatically used by Critic#find_by_name, so you don't need to call it.
			def self.escape_critic_name(name)
				return name if name =~ /^[a-z\-]+$/  # might be escaped already
				name.downcase.gsub(/[^a-z\s]/, ' ').gsub(/\s+/, '-')
			end
			
			##
			# Find a critic record matching a given name. Both the English name (eg, 'A. O. Scott') and the SEO name ('a-o-scott') are valid keys, although the SEO name is
			# suggested if you want to avoid ambiguity. Only exact matches are used (no last name searches). If a single matching record is found, returns a single Critic instance.
			# In the admittedly rare chance of 2 distinct critics having the same name, returns an array. Returns nil if no matches are found. 
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
