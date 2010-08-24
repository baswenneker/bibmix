require 'bibmix'

module Bibmix
	module Ccsb
		class TitleQueryEnrichmentHandler 
			include Bibmix::EnrichmentHandlerAbstract
			
			protected
			def init_handler(reference)
				# Initialize the reference collection mechanism.
				@reference_collector = Bibmix::Ccsb::TitleQuery.new()
				
				# Initialize the reference filtering mechanism, load the threshold
				# from the config.
				threshold = Bibmix.get_config('title_relevance_threshold')				
				@reference_filter = Bibmix::ReferenceFilter.new(reference)
				@reference_filter.relevance_threshold = threshold
				
				# Decorate the filter with the FRIL Filter.
				@reference_filter = Bibmix::FilterDecoratorFactory.instance.fril(@reference_filter)
				
				# Initialize the reference integration mechanism.
				@reference_integrator = Bibmix::NaiveReferenceIntegrator.new(reference)
				
				@validator = Bibmix::TitleAttributeValidator.new(Bibmix::TitleAttributeValidator::VALIDATE_BOTH)
			end

		end
	end
end