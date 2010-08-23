require 'bibmix'

module Bibmix
	class FilteredReference
		
		attr_reader :collected_reference, :relevance
		
		def initialize(collected_reference, relevance)
			raise Bibmix::Error if !collected_reference.is_a?(Bibmix::CollectedReference)
			raise Bibmix::Error if !relevance.is_a?(Float)
			
			@collected_reference = collected_reference
			@relevance = [[0, relevance].max, 1].min
		end
		
		def reference
			@collected_reference.reference
		end
	end
end