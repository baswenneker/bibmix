require 'bibsonomy/request'
require 'bibmix/error'

module Bibmix
	module Bibsonomy
		class QueryError < Bibmix::Error
		end
	
		class InvalidQueryParamError < QueryError
		end
		
		class Query < Bibmix::Query
					
			def initialize(q = nil)
				@request = Bibmix::Bibsonomy::Request.new
				
				if !q.nil?
					@response = execute(q) 
				else
					@response = nil
				end
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
end