require 'bibmix'

module Bibmix
	module PipelineAbstract
		
		
		@enrichmenthandlers = []
		@cmeapplication = nil
		@metadataprocessor = nil
		@referencevalidator = nil
		
		def execute_pipeline(citation)
			
			init()
			
			extracted_citation_metadata = @cmeapplication.parse_citation(citation)
			
			reference = @metadataprocessor.process_metadata(extracted_citation_metadata)
				
			if @referencevalidator
				begin
					@referencevalidator.handle_validation_request(@referencevalidator, reference)
				rescue Bibmix::ReferenceValidatorError
					Bibmix::log(self, "Error while validating citation metadata: #{reference}.")
					return reference
				end
			end
			
			@enrichmenthandlers.each do |handler|
				begin
					handler.input_reference = reference
					reference = handler.execute_enrichment_steps
				rescue Bibmix::DataValidatorError
					Bibmix::log(self, "Error while validating enrichment reference#{reference}.")
					return reference
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
			initialize_referencevalidator_chain
		end
		
		def cleanup
			@enrichmenthandlers = []
			@cmeapplication = nil
			@metadataprocessor = nil
			@referencevalidator = nil
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
		
		def initialize_referencevalidator_chain
			raise Bibmix::NotImplementedError
		end
	end
end