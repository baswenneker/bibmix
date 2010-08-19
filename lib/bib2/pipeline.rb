require 'bib2'

module Bib2
	class Pipeline
		include Singleton, Bib2::PipelineAbstract, DesignByContract
		
		protected 
		def initialize_enrichmenthandlers
			@enrichmenthandlers = [
				Bib2::Bibsonomy::TitleQueryEnrichmentHandler.new,
				Bib2::Bibsonomy::AuthorQueryEnrichmentHandler.new
			]
		end
		
		def initialize_cmeapplication
			@cmeapplication = Bib2::Parscit.new
		end
		
		def initialize_metadataprocessor
			@metadataprocessor = Bib2::ParscitMetadataProcessor
		end
		
		def initialize_referencevalidator_chain			
			@enrichmenthandlers.each do |handler|
				if handler.has_validator
					if @referencevalidator.nil?
						@referencevalidator = handler.validator
					else
						@referencevalidator = @referencevalidator.set_next_validator(handler.validator)
					end
				end
			end
		end
	end
end