require 'bib2'

module Bib2
	module CMEApplicationAbstract
		
		attr_accessor :citation, :reference
		
		def parse_citation(citation)
			raise Bib2::NotImplementedError
		end
		
	end
end