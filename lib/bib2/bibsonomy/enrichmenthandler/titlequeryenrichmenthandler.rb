require 'bib2'

module Bib2
	module Bibsonomy
		class TitleQueryEnrichmentHandler
			include Bib2::EnrichmentHandlerAbstract
			
			def execute_enrichment_steps
				#super()
				
				result = @input_reference
				collected_refs = collect_references(@input_reference)
				
				if collected_refs.size > 0
					filtered_refs = filter_collected_references(collected_refs.get())
					
					if filtered_refs.size > 0
						integrated_reference = integrate_filtered_references(filtered_refs)
						result = integrated_reference
					end					
				end
				
				result
			end
			
		protected
				
			def collect_references(reference)
				#super(reference)
				query = Bib2::Bibsonomy::TitleQuery.new(reference.title)
				query.response
			end
			
			def filter_collected_references(collected_references)
				#super(collected_references)
				threshold = Bib2.get_config('title_recordlinker_threshold')
				
				filter = ReferenceFilter.new(@input_reference, collected_references)
				filter.relevance_threshold = threshold
				filter = FilterDecoratorFactory.instance.fril(filter)	
						
				filter.filter()				
			end
			
			def integrate_filtered_references(filtered_references)
				#super(filtered_references)
				integrator = NaiveReferenceIntegrator.new(@input_reference)
				
				integrator.integrate(filtered_references)
			end
		end
	end
end