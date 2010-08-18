require 'bib2'

module Bib2
	module Bibsonomy
		class AuthorQueryEnrichmentHandler 
			include Bib2::EnrichmentHandlerAbstract
			
			def initialize(reference)
				super(reference)
				
				# Initialize the reference collection mechanism.
				@reference_collector = Bib2::Bibsonomy::AuthorQuery.new()
				
				# Initialize the reference filtering mechanism, load the threshold
				# from the config.
				threshold = Bib2.get_config('author_relevance_threshold')				
				@reference_filter = ReferenceFilter.new(reference)
				@reference_filter.relevance_threshold = threshold
				
				# Decorate the filter with the FRIL Filter.
				@reference_filter = FilterDecoratorFactory.instance.fril(@reference_filter)
				
				# Initialize the reference integration mechanism.
				@reference_integrator = NaiveReferenceIntegrator.new(reference)
			end

		end
	end
end