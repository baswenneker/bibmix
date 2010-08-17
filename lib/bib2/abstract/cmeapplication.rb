require 'bib2'

module Bib2
	
	class AbstractCMEApplication
		
		attr_accessor :citation, :reference
		
		def parse(citation)
			raise Bib2::NotImplementedError
		end
		
	end
end