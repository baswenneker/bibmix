require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		
		class TitleQueryMergerError < QueryMergerError; end
		
		class TitleQueryMergerInvariantError < TitleQueryMergerError;	end
	
		class TitleQueryMergerEmptyQueryResultError < TitleQueryMergerError; end
			
		class TitleQueryMerger < Bibmix::Bibsonomy::QueryMerger
			
			def merge(*args)				
				raise TitleQueryMergerInvariantError unless invariant
				raise TitleQueryMergerEmptyQueryResultError if @query.response.size == 0
							
				@result = @query.first
			end
		end
	end
end