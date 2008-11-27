require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestNytimes::TestMovies::TestResultSet < Test::Unit::TestCase
	include Nytimes::Movies

	def setup
		@result_set = ResultSet.new(123, 20, [MOVIE_REVIEW_HASH])
	end
	
	context "first_index" do
		should "equal the offset + 1" do
			assert_equal 21, @result_set.first_index
		end
	end
	
	context "last_index" do
		should "equal the first_index + batch_size - 1" do
			assert_equal 40, @result_set.last_index
		end
	end
	
	context "page" do
		should "equal the offset / batch_size + 1" do
			assert_equal 2, @result_set.page
		end
	end
end