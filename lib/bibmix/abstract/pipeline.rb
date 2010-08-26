require 'bibmix'

module Bibmix
	module PipelineAbstract
		
		
		@enrichmenthandlers = []
		@cmeapplication = nil
		@metadataprocessor = nil
		
		def execute_pipeline(citation)
			
			init()
			
			extracted_citation_metadata = @cmeapplication.parse_citation(citation)
			
			reference = @metadataprocessor.process_metadata(extracted_citation_metadata)
						
			Bibmix::log(self, "Starting with enrichmenthandlers (#{reference.to_yaml})")
			@enrichmenthandlers.each do |handler|
				
				Bibmix::log(self, "Starting with handler (#{handler})")
				handler.input_reference = reference
				if handler.is_valid_input_reference
					reference = handler.execute_enrichment_steps
				else
					Bibmix::log(self, "Invalid reference, skipping handler, #{reference}.")
				end
			end
			
			cleanup()
			
			reference
		end
		
		protected
		def init
			initialize_cmeapplication
			initialize_metadataprocessor
			initialize_enrichmenthandlers
		end
		
		def cleanup
			@enrichmenthandlers = []
			@cmeapplication = nil
			@metadataprocessor = nil
		end
		
		def initialize_enrichmenthandlers
			raise Bibmix::NotImplementedError
		end
		
		def initialize_cmeapplication
			raise Bibmix::NotImplementedError
		end
		
		def initialize_metadataprocessor
			raise Bibmix::NotImplementedError
		end
	end
end