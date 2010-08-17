require 'bib2'

module Bib2
	class NaiveReferenceIntegrator < AbstractReferenceIntegrator
		
		def integrate(reference)
			
			if reference.kind_of?(Array)
				reference.each do |ref|
					integrate(ref)
				end				
			else
				@target_reference = @target_reference.merge(reference)
			end
			
			@target_reference
		end
		
	end
end