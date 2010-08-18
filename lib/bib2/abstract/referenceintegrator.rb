require 'bib2'

module Bib2
	module ReferenceIntegratorAbstract
		
		attr_reader :target_reference
		
		def initialize(target_reference)
			raise Bib2::Error if !target_reference.is_a?(Bib2::AbstractReference)
			@target_reference = target_reference
		end
		
		def integrate(reference)
			raise Bib2::NotImplementedError
		end
	end
end