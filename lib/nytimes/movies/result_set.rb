module Nytimes
	module Movies
		class ResultSet
			attr_reader :num_results, :offset, :results
			
			def initialize(num_results, offset, results)
				@num_results = num_results
				@offset = offset
				@results = results
			end
			
			def first_index
				offset + 1
			end
			
			def last_index
				first_index + batch_size - 1
			end
			
			def page
				offset / batch_size + 1
			end
			
			def batch_size
				Review::BATCH_SIZE
			end
		end
	end
end