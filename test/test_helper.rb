require 'test/unit'
require 'rubygems'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'FakeWeb'
require 'fake_web'

require File.dirname(__FILE__) + '/../lib/nytimes/movies'

API_KEY = '13e234323232222'
Nytimes::Movies::Base.api_key = API_KEY

def api_url_for(path, params = {})
	full_params = params.merge 'api-key' => API_KEY
	Nytimes::Movies::Base.build_request_url(path, full_params).to_s
end

module TestNytimes
	module TestMovies
	end
end