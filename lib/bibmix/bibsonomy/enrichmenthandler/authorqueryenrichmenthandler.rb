require 'bibmix'

module Bibmix
	module Bibsonomy
		class AuthorQueryEnrichmentHandler 
			include Bibmix::EnrichmentHandlerAbstract
			
			HANDLER_NAME = 'bibsonomy_author'
			
			protected
			def init_handler(reference)
				# Initialize the reference collection mechanism.
				@reference_collector = Bibmix::Bibsonomy::AuthorQuery.new()
				
				# Initialize the reference filtering mechanism, load the threshold
				# from the config.
				threshold = Bibmix.get_config('author_relevance_threshold')				
				@reference_filter = ReferenceFilter.new(reference)
				@reference_filter.relevance_threshold = threshold
				
				# Decorate the filter with the FRIL Filter.
				@reference_filter = FilterDecoratorFactory.instance.fril(@reference_filter)
				
				# Initialize the reference integration mechanism.
				@reference_integrator = NaiveReferenceIntegrator.new(reference, AuthorQueryEnrichmentHandler::HANDLER_NAME)
				
				@validators << Bibmix::AuthorAttributeValidator << Bibmix::MergedBibsonomyTitleQueryValidator
			end
		end
	end
end