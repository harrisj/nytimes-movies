require 'test/unit'
require 'rubygems'
gem 'thoughtbot-shoulda'
require 'shoulda'
gem 'FakeWeb'
require 'fake_web'
require 'mocha'
require 'json'

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

MOVIE_REVIEW_HASH =  {"dvd_release_date"=>"2008-09-16", "opening_date"=>"2008-04-18", 
											"multimedia"=>{"resource"=>{"src"=>"http://graphics8.nytimes.com/images/2008/04/18/arts/18sword-75.jpg", "type"=>"thumbnail", "height"=>75, "width"=>75}}, 
											"byline"=>"Stephen Holden", 
											"nyt_movie_id"=>405736, 
											"publication_date"=>"2008-04-18", "critics_pick"=>"Y", "sort_name"=>"Constantine's Sword", "headline"=>"", 
											"summary_short"=>"u201cConstantineu2019s Swordu201d asks: When your core beliefs conflict with church doctrine, how far should your loyalty to the church extend?", 
											"thousand_best"=>"N",
											"mpaa_rating"=>"NR", 
											"related_urls"=>[{"suggested_link_text"=>"Overview of Constantine's Sword", "url"=>"http://movies.nytimes.com/movie/405736/Constantine-s-Sword/overview", "type"=>"overview"}, {"suggested_link_text"=>"Tickets & Showtimes for Constantine's Sword", "url"=>"http://movies.nytimes.com/movie/405736/Constantine-s-Sword/showtimes", "type"=>"showtimes"}, {"suggested_link_text"=>"Cast, Credits & Awards for Constantine's Sword", "url"=>"http://movies.nytimes.com/movie/405736/Constantine-s-Sword/details", "type"=>"awards"}, {"suggested_link_text"=>"Readers' Reviews of Constantine's Sword", "url"=>"http://movies.nytimes.com/movie/405736/Constantine-s-Sword/rnr", "type"=>"community"}, {"suggested_link_text"=>"Trailers & Clips for Constantine's Sword", "url"=>"http://movies.nytimes.com/movie/405736/Constantine-s-Sword/trailers", "type"=>"trailers"}], 
											"seo-name"=>"Constantine-s-Sword",
											"display_title"=>"Constantine's Sword", 
											"link"=>{"suggested_link_text"=>"Read the New York Times Review of Constantine's Sword", "url"=>"http://movies.nytimes.com/", "type"=>"article"}, 
											"date_updated"=>"2008-08-21 12:10:38"}

MOVIE_RESULT_HASH = {
	"status" => "OK",
	"copyright" => "Copyright (c) 2008 The New York Times Company.  All Rights Reserved.",
	"num_results" => 1,
	"results" => [MOVIE_REVIEW_HASH]
}

MOVIE_RESULT_REPLY = MOVIE_RESULT_HASH.to_json