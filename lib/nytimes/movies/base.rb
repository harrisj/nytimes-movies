require 'open-uri'
require 'json'

module Nytimes
	module Movies
		class Base
			API_SERVER = 'api.nytimes.com'
			API_VERSION = 'v2'
			API_NAME = 'movies'
			API_BASE = "/svc/#{API_NAME}/#{API_VERSION}"
			
			@@api_key = nil
			@@copyright = nil
			
			class << self
				
				##
				# The copyright footer to be placed at the bottom of any data from the New York Times. Note this is only set after an API call.
				def copyright
					@@copyright
				end
				
				##
				# Set the API key used for operations. This needs to be called before any requests against the API. To obtain an API key, go to http://developer.nytimes.com/
				def api_key=(key)
					@@api_key = key
				end
				
				def api_key
					@@api_key
				end
				
				##
				# Builds a request URI to call the API server
				def build_request_url(path, params)
					URI::HTTP.build :host => API_SERVER,
													:path => "#{API_BASE}/#{path}",
													:query => params.map {|k,v| "#{k}=#{v}"}.join('&')
				end
				
				def invoke(path, params={})
					begin
						if @@api_key.nil?
							raise "You must initialize the API key before you run any API queries"
						end
						
						full_params = params.merge 'api-key' => @@api_key
						
						uri = build_request_url(path, full_params)
						
						# puts "Request  [#{uri}]"
						
						reply = uri.read
						parsed_reply = JSON.parse reply
						
						if parsed_reply.nil?
							# FIXME
							raise "Empty reply returned from API"
						end
						
						#case parsed_reply['status']
						# FIXME
						#end
						
						@@copyright = parsed_reply['copyright']
						
						parsed_reply
					rescue OpenURI::HTTPError => e
						if e.message =~ /^404/
							return nil
						end
						
						raise "Error connecting to URL #{uri} #{e}"
					#rescue JSON::ParserError => e
						# raise RuntimeError, "Invalid JSON returned from CRNR:\n#{reply}"
					end
				end
			end
		end
	end
end