require 'bib2'

module Bib2
	class NaiveReferenceIntegrator
		include ReferenceIntegratorAbstract, DesignByContract
		
		pre(	'Parameter filtered_reference should be a Bib2::FilteredReference instance or an Array of Bib2::FilteredReference instances') {|filtered_reference| filtered_reference.is_a?(Bib2::FilteredReference) || (filtered_reference.is_a?(Array))}
		post(	'Return value should be a Bib2::AbstractReference instance') {|result, filtered_reference| result.is_a?(Bib2::AbstractReference)}
		def integrate(filtered_reference)
			
			if filtered_reference.kind_of?(Array)
				filtered_reference.each do |ref|
					integrate(ref)
				end				
			else
				Bib2::log(self, "Integrating #{filtered_reference} with #{@target_reference}")
				
				@target_reference = @target_reference.merge(filtered_reference)
			end
			
			@target_reference
		end
		
	end
end