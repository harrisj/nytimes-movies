require File.dirname(__FILE__) + '/../../test_helper.rb'

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

class TestNytimes::TestMovies::TestReview < Test::Unit::TestCase
	include Nytimes::Movies
	
	# global setup
	def setup
		FakeWeb.clean_registry
		FakeWeb.block_uri_pattern(Base::API_SERVER)
	end
	
	context "Review.create_from_api" do
		setup do
			@review = Review.create_from_api(MOVIE_REVIEW_HASH)
		end
		
		should "rename seo-name to seo_name" do
			assert_equal MOVIE_REVIEW_HASH['seo-name'], @review.seo_name
		end

		should "return a MultimediaLink object for thumbnail" do
			assert_kind_of MultimediaLink, @review.thumbnail
		end
		
		context "link" do
			should "return a Link object" do
				assert_kind_of Link, @review.link
			end
			
			should "map the URL" do
				assert_equal MOVIE_REVIEW_HASH['link']['url'], @review.link.url
			end
		end
		
		context "related links" do
			should "return an array of Link objects" do
				assert_kind_of Array, @review.related_links
				@review.related_links.all? {|l| assert_kind_of(Link, l)}
			end
			
			should "be one for each link object" do
				assert_equal MOVIE_REVIEW_HASH["related_urls"].length, @review.related_links.length
			end
		end
		
		should "map the critics_pick to a boolean" do
			assert_equal true, @review.critics_pick?
		end
		
		should "map the thousand_best to a boolean" do
			assert_equal false, @review.thousand_best?
		end
		
		%w(nyt_movie_id display_title sort_name mpaa_rating byline headline summary_short).each do |field|
			should "copy the #{field} from the hash into a class attribute" do
				assert_equal MOVIE_REVIEW_HASH[field], @review.send(field)
			end
		end

		%w(dvd_release_date opening_date date_updated publication_date).each do |date|		
			should "parse the #{date} from the hash into a Ruby Date" do
				assert_kind_of Date, @review.send(date)
				assert_equal Date.parse(MOVIE_REVIEW_HASH[date]), @review.send(date)
			end
		end
	end
end