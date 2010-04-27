require 'bibmix/error'

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
			raise Bibmix::NotImplementedError
		end
		
	end
end