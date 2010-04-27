module Bibmix
	
	class QueryMergerError < RuntimeError
	end
	
	class QueryMerger
		
		attr_reader :base, :query, :result
		
		def initialize(base, query)
			@base = base
			@query = query
			@result = nil
		end
		
		def merge(*args)		
			raise Bibmix::NotImplementedError
		end

	end
end