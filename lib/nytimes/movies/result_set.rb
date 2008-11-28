module Nytimes
	module Movies
		class ResultSet
			attr_reader :num_results, :offset, :results
			
			def initialize(params, json_reply, coerce_type)
				@num_results = json_reply['num_results']
				@params = params.dup
				@offset = @params['offset'] || 0
				@results = json_reply['results'].map {|r| coerce_type.create_from_api(r)}
			end
			
			##
			# The first display index of the result set. Note this is a human index, not a programmer index; it starts from 1
			def first_index
				offset + 1
			end
			
			##
			# The last display index of the result set.
			def last_index
				first_index + batch_size - 1
			end
			
			##
			# The page of this result set
			def page_number
				offset / batch_size + 1
			end
			
			def num_pages
				(num_results.to_f / batch_size).ceil
			end
			
			##
			# The number of results returned in a result set
			def batch_size
				Review::BATCH_SIZE
			end
			
			def next_page
			end
			
			alias per_page batch_size
		end
	end
end