require 'bib2'

module Bib2	
	module ReferenceCollectorAbstract
				
		@request = nil
		@response = nil
		
		attr_reader :response
		
		def initialize
			raise Bib2::NotImplementedError
		end
		
		def collect_references
			raise Bib2::NotImplementedError
		end
		
	end
end