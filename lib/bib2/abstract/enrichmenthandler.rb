require 'bib2'

module Bib2
	module EnrichmentHandlerAbstract
		include DesignByContract 
		
		@input_reference = nil
		
		def initialize(reference)
			raise Bib2::Error if !reference.is_a?(Bib2::AbstractReference)
			@input_reference = reference
		end
		
		def execute_enrichment_steps			
		end
		pre(	:execute_enrichment_steps, 'Property @input_reference should be a Bib2::AbstractReference instance') { puts 'xx'; @input_reference.is_a?(Bib2::AbstractReference) }
		post(	:execute_enrichment_steps, 'Return value should be a Bib2::AbstractReference') { |result| result.is_a?(Bib2::AbstractReference) }		
		
	protected
		def collect_references(reference)
		end
		pre(	:collect_references, 'Parameter reference should be a Bib2::AbstractReference instance') { |reference| reference.is_a?(Bib2::AbstractReference) }
		pre(	:collect_references, 'Parameter reference should have a title') { |reference| !reference.title.nil? }
		post(	:collect_references, 'Return value should be a Bib2::AbstractResponse') { |result, reference| result.is_a?(Bib2::AbstractResponse) }
		
		def filter_collected_references(collected_references)
		end
		pre(	:filter_collected_references, 'Parameter collected_references should be an Array') { |collected_references| collected_references.is_a?(Array) }
		post(	:filter_collected_references, 'Return value should be an Array with Bib2::FilteredReference instances') { |result, collected_references| result.is_a?(Array) }
		
		def integrate_filtered_references(filtered_references)
		end
		pre(	:integrate_filtered_references, 'Parameter filtered_references should be an Array') { |filtered_references| filtered_references.is_a?(Array) }
		post(	:integrate_filtered_references, 'Return value should be a Bib2::AbstractReference instance') { |result, collected_references| result.is_a?(Bib2::AbstractReference) }
		
	end
end