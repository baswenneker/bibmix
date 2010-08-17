require 'bib2'

module Bib2
	class AbstractReferenceIntegrator
		
		attr_reader :target_reference
		
		def initialize(target_reference)
			@target_reference = target_reference
		end
		
		def integrate(reference)
			raise Bib2::NotImplementedError
		end
	end
end