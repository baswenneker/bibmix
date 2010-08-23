require 'bibmix'

module Bibmix	
	module ReferenceCollectorAbstract
				
		@request = nil
		@response = nil
		
		attr_reader :response
		
		def initialize
			raise Bibmix::NotImplementedError
		end
		
		def collect_references
			raise Bibmix::NotImplementedError
		end
		
	end
end