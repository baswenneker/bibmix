require 'bibmix'

module Bibmix
	class Pipeline
		include Singleton, Bibmix::PipelineAbstract, DesignByContract
		
		protected 
		def initialize_enrichmenthandlers
			@enrichmenthandlers = [
				Bibmix::Bibsonomy::TitleQueryEnrichmentHandler.new,
				Bibmix::Bibsonomy::AuthorQueryEnrichmentHandler.new,
				Bibmix::Ccsb::TitleQueryEnrichmentHandler.new
			]
		end
		
		def initialize_cmeapplication
			@cmeapplication = Bibmix::Parscit.new
		end
		
		def initialize_metadataprocessor
			@metadataprocessor = Bibmix::ParscitMetadataProcessor
		end
	end
end