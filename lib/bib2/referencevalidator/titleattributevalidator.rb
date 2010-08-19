require 'bib2'

module Bib2
	class TitleAttributeValidator
		include ReferenceValidatorAbstract
					
		protected
		def validate_both(reference)
			reference.title.is_a?(String) && !reference.title.empty?
		end
	end
end
