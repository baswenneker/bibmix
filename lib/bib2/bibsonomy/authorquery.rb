require 'bib2'

module Bib2
	module Bibsonomy
			
		class AuthorQuery < Bib2::Bibsonomy::Query
			
			def execute(author=nil)
				
				if @response.nil?
					
					if !author.kind_of?(String)
						raise InvalidQueryParamError, "Invalid query param (#{author.inspect})."
					end
					
					begin
						@response = @request.send(author, 'posts')
						Bib2.log(self, "#{author}: #{@response.size}")
					rescue RequestError
						@response = false
					end
				end
				
				@response
			end
			
		end
	end
end