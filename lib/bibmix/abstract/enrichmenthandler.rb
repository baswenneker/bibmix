require 'bibmix'

module Bibmix
	module EnrichmentHandlerAbstract
		include DesignByContract
		
		@input_reference = nil
		@validator = nil
		
		def initialize(reference=nil)
			
			@input_reference = reference
			init_handler(reference) if !reference.nil?
		end
		
		def input_reference=(reference)
			raise Bibmix::Error if !reference.is_a?(Bibmix::AbstractReference)
			@input_reference = reference
			init_handler(reference)
		end
		
		def has_validator
			!@validator.nil?
		end
						
		pre(	:execute_enrichment_steps, 'Property @input_reference should be a Bibmix::AbstractReference instance') {  @input_reference.is_a?(Bibmix::AbstractReference) }
		post(	:execute_enrichment_steps, 'Return value should be a Bibmix::AbstractReference') { |result| result.is_a?(Bibmix::AbstractReference) }		
		def execute_enrichment_steps
			result = @input_reference
			collected_refs = collect_references(@input_reference)
			
			if collected_refs.size > 0
				filtered_refs = filter_collected_references(collected_refs)
				
				if filtered_refs.size > 0
					integrated_reference = integrate_filtered_references(filtered_refs)
					result = integrated_reference
				end					
			end
			
			result
		end
		
	protected
		
		def init_handler(reference)
			raise Bibmix::NotImplementedError
		end
			
		pre(	:collect_references, 'Parameter reference should be a Bibmix::AbstractReference instance') { |reference| reference.is_a?(Bibmix::AbstractReference) }
		pre(	:collect_references, 'Parameter reference should have a title') { |reference| !reference.title.nil? }
		post(	:collect_references, 'Return value should be an Array of Bibmix::AbstractResponse') { |result, reference| result.is_a?(Array) && result.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::CollectedReference) } }
		def collect_references(reference) 			
			@reference_collector.collect_references(reference)
		end
		
		pre(	:filter_collected_references, 'Parameter collected_references should be an Array') { |collected_references| collected_references.is_a?(Array) }
		post(	:filter_collected_references, 'Return value should be an Array with Bibmix::FilteredReference instances') { |result, collected_references| result.is_a?(Array) }
		def filter_collected_references(collected_references)
			@reference_filter.filter(collected_references)		
		end
		
		pre(	:integrate_filtered_references, 'Parameter filtered_references should be an Array') { |filtered_references| filtered_references.is_a?(Array) }
		post(	:integrate_filtered_references, 'Return value should be a Bibmix::AbstractReference instance') { |result, collected_references| result.is_a?(Bibmix::AbstractReference) }
		def integrate_filtered_references(filtered_references)				
			@reference_integrator.integrate(filtered_references)
		end

	end
end