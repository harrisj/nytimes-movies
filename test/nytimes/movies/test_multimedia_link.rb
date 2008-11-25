require File.dirname(__FILE__) + '/../../test_helper.rb'

LINK_HASH = {"resource" => {"type" => "image","src" => "http:\/\/graphics8.nytimes.com\/images\/2007\/03\/02\/movies\/scott.163.jpg", "height" => 234, "width" => 345,"credit" => "Tony Cenicola\/<br>The New York Times"}}.freeze


class TestNytimes::TestMovies::TestMultimediaLink < Test::Unit::TestCase
	context "MultimediaLink.create_from_api" do
		setup do
			@link = Nytimes::Movies::MultimediaLink.create_from_api(LINK_HASH)
		end
		
		should "return an instance of MultimediaLink" do
		  assert_kind_of(Nytimes::Movies::MultimediaLink, @link)
		end
		
		should "assign the @media_type attribute from the 'type' key in the hash" do
		  assert_equal(LINK_HASH['resource']['type'], @link.media_type)
		end
		
		should "assign the @url attribute from the 'src' key in the hash" do
		  assert_equal(LINK_HASH['resource']['src'], @link.url)
		end
		
		should "assign the @height attribute from the 'height' key in the hash" do
		  assert_equal(LINK_HASH['resource']['height'], @link.height)
		end
		
		should "assign the @width attribute from the 'width' key in the hash" do
		  assert_equal(LINK_HASH['resource']['width'], @link.width)
		end
		
		should "assign the @credit attribute from the 'credit' key in the hash" do
		  assert_equal(LINK_HASH['resource']['credit'], @link.credit)
		end
	end
end