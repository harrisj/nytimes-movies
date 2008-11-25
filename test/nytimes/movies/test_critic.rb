require File.dirname(__FILE__) + '/../../test_helper.rb'

CRITIC_HASH = {"display_name" => "A. O. Scott",
							 "sort_name" => "A. O. Scott",
							 "status" => "full-time",
							 "bio" => "A. O. Scott joined The New York Times as a film critic in January 2000. Previously, Mr. Scott was a Sunday book reviewer for Newsday and a frequent contributor to Slate, The New York Review of Books, and many other publications.  He has served on the editorial staffs of Lingua Franca and The New York Review of Books.  He also edited \"A Bolt from the Blue and Other Essays,\" a collection by Mary McCarthy, which was published by The New York Review of Books in 2002. In addition to his film-reviewing duties, Mr. Scott often writes for the Times Magazine and the Book Review.  He was born on July 10, 1966, in Northampton, Mass., and now lives in Brooklyn, N.Y. with his wife and two children.",
							 "seo_name" => "A-O-Scott",
							 "multimedia" => {"resource" => {"type" => "image","src" => "http:\/\/graphics8.nytimes.com\/images\/2007\/03\/02\/movies\/scott.163.jpg", "height" => nil,"width" => nil,"credit" => "Tony Cenicola\/<br>The New York Times"}}}

FIND_BY_NAME_REPLY = <<-EOF
{"status":"OK","copyright":"Copyright (c) 2008 The New York Times Company.  All Rights Reserved.","results":[{"display_name":"A. O. Scott","sort_name":"A. O. Scott","status":"full-time","bio":"A. O. Scott joined The New York Times as a film critic in January 2000. Previously, Mr. Scott was a Sunday book reviewer for Newsday and a frequent contributor to Slate, The New York Review of Books, and many other publications.  He has served on the editorial staffs of Lingua Franca and The New York Review of Books.  He also edited \\\"A Bolt from the Blue and Other Essays,\\\" a collection by Mary McCarthy, which was published by The New York Review of Books in 2002. In addition to his film-reviewing duties, Mr. Scott often writes for the Times Magazine and the Book Review.  He was born on July 10, 1966, in Northampton, Mass., and now lives in Brooklyn, N.Y. with his wife and two children.","seo_name":"A-O-Scott","multimedia":{"resource":{"type":"image","src":"http://graphics8.nytimes.com/images/2007/03/02/movies/scott.163.jpg","height":null,"width":null,"credit":"Tony Cenicola/<br>The New York Times"}}}]}
EOF

class TestNytimes::TestMovies::TestCritic < Test::Unit::TestCase
	include Nytimes::Movies
	
	# global setup
	def setup
		FakeWeb.clean_registry
		FakeWeb.block_uri_pattern(Base::API_SERVER)
	end
	
	context "Critic.create_from_api" do
		setup do
			@critic = Critic.create_from_api(CRITIC_HASH)
		end
		
		should "return an object of the Critic type" do
			assert_kind_of(Critic, @critic)
		end
		
		%w(display_name sort_name status bio).each do |attr|
			should "assign the value of the @#{attr} attribute from the '#{attr}' key in the hash" do
				assert_equal(CRITIC_HASH[attr], @critic.send(attr))
			end
		end
		
		context "for the multimedia hash value" do
			should "assign it to the @photo attribute" do
				assert_not_nil @critic.photo
			end
			
			should "return a Nytimes::Movies::MultimediaLink instance" do
				assert_kind_of(MultimediaLink, @critic.photo)
			end
		end
	end
	
	context "Critic.escape_critic_name" do
		should "not escape a name that looks like it's escaped" do
			assert_equal 'a-o-scott', Critic.escape_critic_name('a-o-scott')
		end
			
		should "downcase a name and replace spaces with hyphens" do
			assert_equal 'mahnola-dargis', Critic.escape_critic_name('Mahnola Dargis')
		end
			
		should "not include punctuation characters in the escaped name" do
			assert_equal 'a-o-scott', Critic.escape_critic_name('A.O. Scott')
		end
	end
		
	context "Critic.find_by_name" do
		context "for a valid critic" do
			setup do
				FakeWeb.register_uri(api_url_for('critics/a-o-scott'), :string => FIND_BY_NAME_REPLY)
				@critic = Critic.find_by_name('a-o-scott')			
			end
				
			should "return a single Nytimes::Movies::Critic instance" do	
				assert_kind_of(Critic, @critic)
				assert_equal 'A. O. Scott', @critic.display_name
			end
		end
			
		context "for a nonexistant critic" do
			setup do
				FakeWeb.register_uri(api_url_for('critics/unknown-person'), :string => FIND_BY_NAME_REPLY, :status => [ 404, "Not Found" ])
				@critic = Critic.find_by_name('Unknown Person')
			end
				
			should "return nil" do
				assert_nil @critic
			end
		end
	end
		
	context "Critic.find_by_type" do
		setup do
			FakeWeb.register_uri(api_url_for('critics/full-time'), :string => FIND_BY_NAME_REPLY)
		end
			
		should "raise an ArgumentError if passed anything besides :full_time, :part_time, or :all" do
			assert_raise(ArgumentError) { Critic.find_by_type(:foo) }
		end
			
		should "return an array of Nytimes::Movies::Critic instances" do
			@critics = Critic.find_by_type(:full_time)
						
			assert_kind_of(Array, @critics)
			assert @critics.all? {|c| c.is_a? Critic}
			assert_equal 'A. O. Scott', @critics.first.display_name
		end
	end
end