require 'bibmix'

module Bibmix
	module ReferenceValidatorAbstract
		
		def self.is_valid_reference(reference)
			raise Bibmix::NotImplementedError
		end
		
	end
end