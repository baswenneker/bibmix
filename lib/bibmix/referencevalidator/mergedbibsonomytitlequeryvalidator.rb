require 'bibmix'

module Bibmix
	class MergedBibsonomyTitleQueryValidator
		include ReferenceValidatorAbstract
					
		def self.is_valid_reference(reference)
			!reference.merged_by.include?(Bibmix::Bibsonomy::TitleQueryEnrichmentHandler::HANDLER_NAME)
		end
	end
end
