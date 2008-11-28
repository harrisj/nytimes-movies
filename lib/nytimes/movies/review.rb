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
			
			BATCH_SIZE = 20
			
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
				
				def format_date_arg(arg)
					return arg if arg.is_a? String
		
					unless arg.respond_to? :strftime
						raise "Date argument must respond to strftime"
					end
					
					arg.strftime "%Y-%m-%d"
				end
				
				def date_to_query_arg(date_or_range)
					return nil if date_or_range.nil?
					if date_or_range.respond_to?(:first) && date_or_range.respond_to?(:last)
						"#{format_date_arg(date_or_range.first)};#{format_date_arg(date_or_range.last)}"
					else
						format_date_arg(date_or_range)
					end
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
				
				##
				# Find Movie Reviews that match your parameters. Up to 3 of the following query parameters can be used in a request:
				#  
				# * <tt>:text</tt> - search movie title and indexed terms for the movie. To limit to exact matches, enclose parts of the query in single quotes. Otherwise, it will include include partial matches ("head words") as well as exact matches (e.g., president will match president, presidents and presidential). Multiple terms will be ORed together
				# * <tt>:critics_pick</tt> - set to true to only search movies that are designated critics picks. Should your tastes be more lowbrow, set to false to return movies that are specifically NOT critic's picks. To get all movies, don't send this parameter at all.
				# * <tt>:thousand_best</tt> - search only movies on the Times List of "Thousand Best Movies Ever Made". Set to false if you want to explicitly search movies not on the list. Omit if you want all movies.
				# * <tt>:dvd</tt> - if true, search only movies out on DVD. If false, movies not on DVD. Don't specify if you want all movies.
				# * <tt>:reviewer</tt> - search reviews made by a specific critic. The full-name or the SEO name can be used to specify the critic.
				# * <tt>:publication_date</tt> - when the review was published. This can be either a single Date or Time object or a range of Times (anything that responds to .first and .last). If you'd prefer, you can also pass in a "YYYY-MM-DD" string
				# * <tt>:opening_date</tt> - when the movie opened in theaters in the NY Metro area. See +:publication_date+ for argument times.
        #
				# In addition, you can also specify the following order and pagination values:
				# * <tt>:offset</tt> - a maximum of 20 result are returned for queries. To retrieve further pages, an offset from the first result can be specified. This must be a multiple of 20. So +20+ means results +21 - 40+
				# * <tt>:page</tt> - as a convenience, page will calculate the offset for here. This is not an API parameter and is translated into an offset.
				# * <tt>:order</tt> - ordering for the results. The following four sorting options are available: <tt>:title</tt> (<em>ascending</em>), <tt>:publication_date</tt>, <tt>:opening_date</tt>, <tt>:dvd_release_date</tt> (<em>most recent first</em>). If you do not specify a sort order, the results will be ordered by closest match.
				def find(in_params={})
					params = {}
					
					if in_params[:text]
						params['query'] = in_params[:text]
					end

					params['thousand-best'] = boolean_to_query_arg(in_params[:thousand_best])
					params['critics-pick'] = boolean_to_query_arg(in_params[:critics_pick])
					params['dvd'] = boolean_to_query_arg(in_params[:dvd])
					
					params['publication-date'] = date_to_query_arg(in_params[:publication_date])
					params['opening-date'] = date_to_query_arg(in_params[:opening_date])
										
					if in_params.has_key? :reviewer
						params['reviewer'] = Critic.escape_critic_name(in_params[:reviewer])
					end
					
					params['offset'] = in_params[:offset]
					
					if in_params.has_key? :page
						params['offset'] = BATCH_SIZE * (in_params[:page] - 1)
					end
					
					if in_params.has_key? :order
						params['order'] = case in_params[:order]
						when :title, :publication_date, :opening_date, :dvd_release_date
							"by-#{in_params[:order].to_s.gsub('_', '-')}"
						else
							raise ArgumentError, "Order can only be :title, :publication_date, :opening_date, or :dvd_release_date"
						end
					end
					
					params.delete_if {|k, v| v.nil? }
					
					reply = invoke 'reviews/search', params
					ResultSet.new(reply['num_results'], params['offset'], reply['results'])			
				end
				
				def find_by_type(params={})
				end
				
				def find_by_reviewer(params={})
				end
			end
		end
	end
end
