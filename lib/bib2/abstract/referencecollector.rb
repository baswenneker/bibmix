require 'bib2'

module Bib2
	
	class AbstractReferenceCollector
		
		attr_reader :response
		
		def initialize(q=nil)
			raise Bib2::NotImplementedError
		end
		
		def execute(q=nil)
			raise Bib2::NotImplementedError
		end
				
		def first(q=nil)
			execute(q)
			
			if @response.eql?(false) || @response.size == 0
				return false
			end
			
			@response.get().first			
		end
		
	end
end