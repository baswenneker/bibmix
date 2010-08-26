require 'bibmix'

module Bibmix
	class TitleAttributeValidator
		include ReferenceValidatorAbstract
					
		def self.is_valid_reference(reference)
			reference.title.is_a?(String) && !reference.title.empty?
		end
	end
end
