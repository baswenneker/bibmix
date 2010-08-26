require 'bibmix'

module Bibmix
	class AuthorAttributeValidator
		include ReferenceValidatorAbstract
					
		def self.is_valid_reference(reference)
			reference.author.is_a?(Array) && !reference.author.empty?
		end
	end
end
