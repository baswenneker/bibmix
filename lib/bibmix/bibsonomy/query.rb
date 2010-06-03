require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		
		class QueryError < Bibmix::Error;	end	
		class InvalidQueryParamError < QueryError; end
		
		class Query < Bibmix::Query
					
			def initialize(q = nil)				
				@request = Bibmix::Bibsonomy::Request.new
				
				if !q.nil?
					@response = execute(q) 
				else
					@response = nil
				end
			end

		end
	end
end