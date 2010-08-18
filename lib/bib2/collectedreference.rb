require 'bib2'

module Bib2
	class CollectedReference
		
		attr_reader :reference, :source
		
		def initialize(reference, source)	
			raise Bib2::Error if !reference.is_a?(Bib2::AbstractReference)
			raise Bib2::Error if !source.is_a?(String)
			
			@reference = reference
			@source = source
		end
	end
end