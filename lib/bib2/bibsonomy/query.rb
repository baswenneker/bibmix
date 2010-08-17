require 'bib2'

module Bib2
	module Bibsonomy
		
		class QueryError < Bib2::Error;	end	
		class InvalidQueryParamError < QueryError; end
		
		class Query < Bib2::AbstractReferenceCollector
					
			def initialize(q = nil)				
				@request = Bib2::Bibsonomy::Request.new
				
				if !q.nil?
					@response = execute(q) 
				else
					@response = nil
				end
			end

		end
	end
end