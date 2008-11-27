require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestNytimes::TestMovies::TestReview < Test::Unit::TestCase
	include Nytimes::Movies
	
	# global setup
	def setup
		FakeWeb.clean_registry
		FakeWeb.block_uri_pattern(Base::API_SERVER)
	end
	
	def expects_invoke_arg(key, value)
		Review.expects(:invoke).with(anything, has_entry(key, value)).returns(MOVIE_RESULT_HASH)
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

	context "Review.find" do
		setup do
			FakeWeb.register_uri(api_url_for('reviews/search', 'query' => 'constantine'), :string => MOVIE_RESULT_REPLY)
		end
		
		should "call the reviews/search endpoint"
		
		should "return an instance of ResultSet" do
			result_set = Review.find(:text => 'constantine')
			assert_kind_of(ResultSet, result_set)
		end
		
		context "input parameters" do
			context "text" do
			end
			
			context "critic_name" do
				should "escape the Critic Name to the SEO form" do
					expects_invoke_arg('reviewer', 'a-o-scott')
					Review.find(:reviewer => 'A. O. Scott')
				end
				
				should "not escape again if already in SEO form" do
					expects_invoke_arg('reviewer', 'a-o-scott')
					Review.find(:reviewer => 'A. O. Scott')
				end
			end
		
			context "page" do
				should "set the offset to be batchsize * page-1" do
					expects_invoke_arg('offset', 40)
					Review.find(:page => 3)
				end
			end
		
			context "ordering parameters" do
				should "send a by-title to the API for :title order" do
					expects_invoke_arg('order', 'by-title')
					Review.find(:order => :title)
				end
				
				should "send a by-publication-date to the API for :publication_date order" do
					expects_invoke_arg('order', 'by-publication-date')
					Review.find(:order => :publication_date)
				end
				
				should "send a by-opening-date to the API for :opening_date order" do
					expects_invoke_arg('order', 'by-opening-date')
					Review.find(:order => :opening_date)
				end
				
				should "send a by-dvd-release-date to the API for :dvd_release_date order" do
					expects_invoke_arg('order', 'by-dvd-release-date')
					Review.find(:order => :dvd_release_date)
				end
				
				should "raise an ArgumentError if the ordering is not one of those allowed" do
					assert_raise(ArgumentError) do
						Review.find(:order => :random)
					end
				end
			end
		end
	end
end