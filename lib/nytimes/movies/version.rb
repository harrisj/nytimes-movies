module Nytimes
	module Movies
  	module VERSION #:nodoc:
    	MAJOR = 0
    	MINOR = 0
    	TINY  = 1

    	STRING = [MAJOR, MINOR, TINY].join('.')
    	self
  	end
	end
end