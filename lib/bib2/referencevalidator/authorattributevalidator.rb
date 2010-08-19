require 'bib2'

module Bib2
	class AuthorAttributeValidator
		include ReferenceValidatorAbstract
					
		protected
		def validate_both(reference)
			reference.author.is_a?(Array) && !reference.author.empty?
		end
	end
end
