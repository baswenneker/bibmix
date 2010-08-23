require 'bibmix'

module Bibmix
	module CMEApplicationAbstract
		
		attr_accessor :citation, :reference
		
		def parse_citation(citation)
			raise Bibmix::NotImplementedError
		end
		
	end
end