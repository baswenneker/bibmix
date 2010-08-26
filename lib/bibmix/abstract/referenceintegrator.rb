require 'bibmix'

module Bibmix
	module ReferenceIntegratorAbstract
		
		attr_reader :target_reference
		
		attr_accessor :handler_name
		
		def initialize(target_reference, handler_name='')
			raise Bibmix::Error if !target_reference.is_a?(Bibmix::AbstractReference)
			@target_reference = target_reference
			@handler_name = handler_name
		end
		
		def integrate(reference)
			raise Bibmix::NotImplementedError
		end
	end
end