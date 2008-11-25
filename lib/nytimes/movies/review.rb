module Nytimes
	module Movies
		class Review < Base
			attr_reader :nyt_movie_id, :display_title, :sort_name, :mpaa_rating, :byline, :headline, :summary_short, :publication_date, :opening_date, :dvd_release_date, \
			            :date_updated, :seo_name, :critics_pick, :thousand_best, :thumbnail, :link, :related_links
			
			alias :updated_on :date_updated
			alias :critics_pick? :critics_pick
			alias :thousand_best? :thousand_best
			
			alias :critic_name :byline
			alias :movie_title :display_title
			alias :review_title :headline
			
			def initialize(params={})
				params.each_pair do |k,v|
					instance_variable_set("@#{k}", v)
				end
			end
			
			class <<self
				def parse_date(value)
					return nil if value.nil?
					Date.parse(value)
				end
				
				def rename_hash_key(hash, key, new_key)
					hash[new_key] = hash.delete(key)
				end
				
				def coerce_key_boolean(hash, key)
					hash[key] = hash[key] == 'Y'
				end
				
				def date_to_query_arg(date)
					
				end
				
				def boolean_to_query_arg(arg)
					return nil if arg.nil?
					arg ? 'Y' : 'N'
				end
				
				def create_from_api(hash)
					hash = hash.dup
					
					hash['dvd_release_date'] = parse_date(hash['dvd_release_date'])
					hash['opening_date'] = parse_date(hash['opening_date'])
					hash['publication_date'] = parse_date(hash['publication_date'])
					hash['date_updated'] = parse_date(hash['date_updated'])
					
					coerce_key_boolean hash, 'critics_pick'
					coerce_key_boolean hash, 'thousand_best'
					
					multimedia = hash.delete('multimedia')
					unless multimedia.nil?
						hash['thumbnail'] = MultimediaLink.create_from_api(multimedia)
					end
					
					if hash.has_key? 'link'
						hash['link'] = Link.create_from_api(hash['link'])
					end
					
					related = hash.delete('related_urls')
					unless related.nil?
						hash['related_links'] = related.map {|l| Link.create_from_api(l) }
					end
					
					rename_hash_key hash, 'seo-name', 'seo_name'
					
					new hash
				end
				
				def find_by_keyword(params={})
				end
				
				def find_all(params={})
				end
				
				def find_by_reviewer(params={})
				end
			end
		end
	end
end

# <review nyt_movie_id="72689">
#    <display_title>The Big Chill</display_title>
#    <sort_name>The Big Chill</sort_name>
#    <mpaa_rating>R</mpaa_rating>
#    <critics_pick>Y</critics_pick>
#    <thousand_best>Y</thousand_best>
#    <byline>VINCENT CANBY</byline>
#    <headline>
#    </headline>
#    <summary_short>
#    </summary_short>
#    <publication_date>1983-09-23</publication_date>
#    <opening_date>1983-09-28</opening_date>
#    <dvd_release_date>1999-01-26</dvd_release_date>
#    <date_updated>2008-11-04 03:48:35</date_updated>
#    <seo-name>The-Big-Chill</seo-name>
#    <link type="article">
#       <url>
#          http://movies.nytimes.com/movie/
#          review?res=9507EEDD1E38F930A1575AC0A965948260
#       </url>
#       <suggested_link_text>
#          Read the New York Times Review of The Big Chill
#       </suggested_link_text>
#    </link>
#    <related_urls>
#       <link type="overview">
#          <url>
#            http://movies.nytimes.com/movie/
#            72689/The-Big-Chill/overview
#          </url>
#          <suggested_link_text>
#            Overview of The Big Chill
#          </suggested_link_text>
#       </link>
#       <link type="showtimes">
#          <url>
#            http://movies.nytimes.com/movie/
#            72689/The-Big-Chill/showtimes
#          </url>
#          <suggested_link_text>
#             Tickets & Showtimes for The Big Chill         
#          </suggested_link_text>
#       </link>
#       <link type="awards">
#          <url>
#            http://movies.nytimes.com/movie/72689/
#            The-Big-Chill/details
#          </url>
#          <suggested_link_text>
#             Cast, Credits & Awards for The Big Chill
#          </suggested_link_text>
#       </link>
#       <link type="community">
#          <url>
#            http://movies.nytimes.com/movie/72689/
#            The-Big-Chill/rnr               
#          </url>
#          <suggested_link_text>
#            Readers' Reviews of The Big Chill
#          </suggested_link_text>
#       </link>
#       <link type="trailers">
#          <url>
#            http://movies.nytimes.com/movie/72689/
#            The-Big-Chill/trailers
#          </url>
#          <suggested_link_text>
#             Trailers & Clips for The Big Chill
#          </suggested_link_text>
#       </link>
#    </related_urls>
# </review>
