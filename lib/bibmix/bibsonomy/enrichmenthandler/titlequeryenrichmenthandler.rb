require 'bibmix'

module Bibmix
	module Bibsonomy
		class TitleQueryEnrichmentHandler 
			include Bibmix::EnrichmentHandlerAbstract
			
			HANDLER_NAME = 'bibsonomy_title'
			
			protected
			def init_handler(reference)
				# Initialize the reference collection mechanism.
				@reference_collector = Bibmix::Bibsonomy::TitleQuery.new()
				
				# Initialize the reference filtering mechanism, load the threshold
				# from the config.
				threshold = Bibmix.get_config('bibsonomy_title_relevance_threshold')				
				@reference_filter = ReferenceFilter.new(reference)
				@reference_filter.relevance_threshold = threshold
				
				# Decorate the filter with the FRIL Filter.
				@reference_filter = FilterDecoratorFactory.instance.fril(@reference_filter)
				
				# Initialize the reference integration mechanism.
				@reference_integrator = IntelligentReferenceIntegrator.new(reference, TitleQueryEnrichmentHandler::HANDLER_NAME)
				
				@validators << Bibmix::TitleAttributeValidator
			end

		end
	end
end