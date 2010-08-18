require 'bib2'

module Bib2
	class EnrichmentHandlerInterface
		include DesignByContract
		
		@@input_reference = nil
		
		#def initialize(reference)
		#	raise Bib2::NotImplementedError
		#end
		
		pre(	:execute_enrichment_steps, 'Property @input_reference should be a Bib2::AbstractReference instance') { puts 'xx'; @input_reference.is_a?(Bib2::AbstractReference) }
		post(	:execute_enrichment_steps, 'Return value should be a Bib2::AbstractReference') { |result| result.is_a?(Bib2::AbstractReference) }		
		def execute_enrichment_steps
			raise Bib2::NotImplementedError
		end
		
		protected
		pre(	'Parameter reference should be a Bib2::AbstractReference instance') { |reference| reference.is_a?(Bib2::AbstractReference) }
		pre(	'Parameter reference should have a title') { |reference| !reference.title.nil? }
		post(	'Return value should be a Bib2::AbstractResponse') { |result, reference| result.is_a?(Bib2::AbstractResponse) }
		def collect_references(reference)
			raise Bib2::NotImplementedError
		end
		
		pre(	'Parameter collected_references should be an Array') { |collected_references| collected_references.is_a?(Array) }
		post(	'Return value should be an Array with Bib2::FilteredReference instances') { |result, collected_references| result.is_a?(Array) }
		def filter_collected_references(collected_references)
			raise Bib2::NotImplementedError
		end
		
		pre(	'Parameter filtered_references should be an Array') { |filtered_references| filtered_references.is_a?(Array) }
		post(	'Return value should be a Bib2::AbstractReference instance') { |result, collected_references| result.is_a?(Bib2::AbstractReference) }
		def integrate_filtered_references(filtered_references)
			raise Bib2::NotImplementedError
		end
	end
end