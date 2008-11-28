require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestNytimes::TestMovies::TestResultSet < Test::Unit::TestCase
	include Nytimes::Movies

	def setup
		@reply = MOVIE_RESULT_HASH
		@params = {'offset' => 40}
		@result_set = ResultSet.new(@params, @reply, Review)
	end
	
	context "first_index" do
		should "equal the offset + 1" do
			assert_equal 41, @result_set.first_index
		end
	end
	
	context "last_index" do
		should "equal the first_index + batch_size - 1" do
			assert_equal 60, @result_set.last_index
		end
	end

	context "num_pages" do
		should "equal the ceiling of num_results / batch_size" do
			@result_set.instance_variable_set '@num_results', 123
			
			assert_equal 7, @result_set.num_pages
		end
		
		should "equal 1 if the number of results < batch_size" do
			@result_set.instance_variable_set '@num_results', 1
			assert_equal 1, @result_set.num_pages
		end
		
		should "not erroneously round up if the num_results % batch_size = 0" do
			@result_set.instance_variable_set '@num_results', 120
			assert_equal 6, @result_set.num_pages
		end
	end
	
	context "page_number" do
		should "equal the offset / batch_size + 1" do
			assert_equal 3, @result_set.page_number
		end
	end
	
end