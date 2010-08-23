require 'bibmix'

module Bibmix
	module ReferenceIntegratorAbstract
		
		attr_reader :target_reference
		
		def initialize(target_reference)
			raise Bibmix::Error if !target_reference.is_a?(Bibmix::AbstractReference)
			@target_reference = target_reference
		end
		
		def integrate(reference)
			raise Bibmix::NotImplementedError
		end
	end
end