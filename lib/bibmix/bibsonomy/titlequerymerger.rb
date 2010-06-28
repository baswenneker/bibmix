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
					@result = merge_weighted_hash(hash, 0.9)
				end
				
				@result
			end
			
		end
	end
end