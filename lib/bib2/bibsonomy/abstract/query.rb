require 'bib2'

module Bib2
	module Bibsonomy
		module QueryAbstract
			include Bib2::ReferenceCollectorAbstract
					
			def initialize			
				@request = Bib2::Bibsonomy::Request.new
			end

		end
	end
end