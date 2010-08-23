require 'bibmix'

module Bibmix
	class CollectedReference
		
		attr_reader :reference, :source
		
		def initialize(reference, source)	
			raise Bibmix::Error if !reference.is_a?(Bibmix::AbstractReference)
			raise Bibmix::Error if !source.is_a?(String)
			
			@reference = reference
			@source = source
		end
	end
end