require 'bibmix'

module Bibmix
	
	class QueryMergerError < Bibmix::Error; end
	
	class QueryMerger
		
		attr_reader :base, :query, :result, :similarity_lookup_hash
		
		def initialize(base, query)
			@base = base
			@query = query
			@result = nil
			@similarity_lookup_hash = {}
		end
		
		def merge(*args)		
			raise Bibmix::NotImplementedError
		end

	end
end