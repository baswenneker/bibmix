require 'bibmix'

module Bibmix
	
	class Query
		
		attr_reader :response
		
		def initialize(q=nil)
			raise Bibmix::NotImplementedError
		end
		
		def execute(q=nil)
			raise Bibmix::NotImplementedError
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