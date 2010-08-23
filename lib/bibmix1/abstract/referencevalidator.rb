require 'bibmix'

module Bibmix
	
	class ReferenceValidatorError < Bibmix::Error; end
	
	module ReferenceValidatorAbstract
		
		@validation_condition = nil
		@next_validator = nil
		
		VALIDATE_CITATION_METADATA = 'validate_citation_metadata'
		VALIDATE_ENRICHMENT_REFERENCE = 'validate_enrichment_reference'
		VALIDATE_BOTH = 'validate_both'
		
		def initialize(condition)
			raise Bibmix::Error if ![VALIDATE_CITATION_METADATA, VALIDATE_ENRICHMENT_REFERENCE, VALIDATE_BOTH].include?(condition)			
			@validation_condition = condition
		end
		
		def set_next_validator(validator)
			@next_validator = validator
		end
		
		def handle_validation_request(condition, reference)
			if @validation_condition == condition
				raise Bibmix::ReferenceValidatorError if !self.send("#{condition}", reference)
			elsif @validation_condition == VALIDATE_BOTH
				raise Bibmix::ReferenceValidatorError if !validate_both(reference)
			end
			
			if has_next_validator
				@next_validator.handle_validation_request(condition, reference)
			end
		end
		
		def has_next_validator
			!@next_validator.nil?
		end
		
		protected
		def validate_citation_metadata(reference)
			raise Bibmix::NotImplementedError
		end
		
		def validate_enrichment_reference(reference)
			raise Bibmix::NotImplementedError
		end
		
		def validate_both(reference)
			validate_citation_metadata(reference) && validate_enrichment_reference(reference)
		end
	end
end