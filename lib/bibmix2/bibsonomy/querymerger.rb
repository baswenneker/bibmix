require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		
		class QueryMerger < Bibmix::QueryMerger
			
			def merge(*args)				
				raise Bibmix::NotImplementedError
			end
			
		protected
			def invariant
				@base.kind_of?(Bibmix::Bibsonomy::Record) && @query.kind_of?(Bibmix::Bibsonomy::Query)
			end
		end
	end
end