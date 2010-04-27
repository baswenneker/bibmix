module Bibmix
	module Bibsonomy
		
		class QueryMergerError < Bibmix::Error
		end
		
		class QueryMerger < Bibmix::QueryMerger
			
			def merge(*args)				
				raise Bibmix::NotImplementedError
			end
			
		protected
			def invariant
				@base.kind_of?(Bibmix::Record) && @query.kind_of?(Bibmix::Query)
			end
		end
	end
end