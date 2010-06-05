require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		
		class TitleQueryMergerError < QueryMergerError;	end
		class TitleQueryMergerInvariantError < TitleQueryMergerError;	end
		class TitleQueryMergerEmptyQueryResultError < TitleQueryMergerError; end
			
		class TitleQueryMerger < Bibmix::Bibsonomy::QueryMerger
			
			def merge(*args)				
				raise TitleQueryMergerInvariantError unless invariant
				
				hash = similar_record_hash(@query)
				if hash.empty?
					@result = @query.first
				else
					@result = merge_weighted_hash(hash, 1)
				end
			end
			
#			# Method which assesses the similarity between both records.
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
		end
	end
end