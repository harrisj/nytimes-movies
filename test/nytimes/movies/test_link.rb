require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestNytimes::TestMovies::TestLink < Test::Unit::TestCase
	context "Link.create" do
		setup do
			@url = 'http://foo.com'
			@type = 'article'
			@suggest_text = 'Suggested Text'
			
			@link = Nytimes::Movies::Link.create_from_api('url' => @url, 'type' => @type, 'suggested_link_text' => @suggest_text)
		end
		
		should "return an object of type Nytimes::Movies::Link" do
			assert_kind_of(Nytimes::Movies::Link, @link)
		end
		
		should "assign the @url attribute from the 'url' key in the hash" do
			assert_equal(@url, @link.url)
		end
		
		should "assign the @link_type attribute from the 'type' key in the hash" do
		  assert_equal(@type, @link.link_type)
		end
		
		should "assign the @suggested_text attribute from the 'suggested_link_text' key in the hash" do
		  assert_equal(@suggest_text, @link.suggested_text)
		end
	end
end
