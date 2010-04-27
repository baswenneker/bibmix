#require 'bibsonomy/query'

module Bibmix
	module Bibsonomy
		class TitleQuery < Bibmix::Bibsonomy::Query
			
			def execute(q=nil)
				
				if @response.nil?
					begin
						@response = @request.send(q, 'posts')
					rescue RequestError
						@response = false
					end	
				end
				
				@response
			end
			
		end		
	end
end