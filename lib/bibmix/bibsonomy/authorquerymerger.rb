require 'bibmix/bibsonomy'
require 'amatch'

module Bibmix
	module Bibsonomy
		
		class AuthorQueryMergerError < Bibmix::QueryMergerError;	end
		class AuthorQueryMergerInvariantError < AuthorQueryMergerError;	end
		class AuthorQueryMergerEmptyQueryResultError < AuthorQueryMergerError; end
		class AuthorQueryMergerInvalidSimilarityParamError < AuthorQueryMergerError; end
			
		class AuthorQueryMerger < Bibmix::Bibsonomy::QueryMerger
			
			def initialize(base, query)
				super(base, query)
			end
						
			def merge(*args)
				raise AuthorQueryMergerInvariantError unless invariant
								
				# The intrahashes are used to filter out duplicate entries.
				# Read more about hashes @bibsonomy: <http://www.bibsonomy.org/help/doc/inside.html>
				hash = {}
				@query.each do |query|
					hash = hash.merge(similar_record_hash(query))
				end
				
				raise AuthorQueryMergerEmptyQueryResultError if hash.size == 0
				
				@result = merge_weighted_hash(hash,0.75)
			end
			
			# Method which assesses the similarity between both records.
#			def assess_similarity(rec1, rec2)
#	
#				# assess similarity based on hash and title
#				similarity = super(rec1, rec2)
#				return 1 if similarity == 1
#				
#				# asses string similarity of the title using pair distance similarity measure
#				title_similarity = rec1.title.pair_distance_similar(rec2.title)
#					
#				# return the max of both
#				[similarity, title_similarity].max
#			end
			
		protected
			def invariant
				@base.kind_of?(Bibmix::Record) && @query.kind_of?(Array)
			end
		end
	end
end