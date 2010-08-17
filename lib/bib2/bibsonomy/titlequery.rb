require 'bib2'

module Bib2
	module Bibsonomy
		class TitleQuery < Bib2::Bibsonomy::Query
			
			def execute(q=nil)
				raise Bib2::QueryError("Invalid query param (#{q}, #{q.class})") unless q.nil? || q.class == String

				if @response.nil?
					# Only do the actual request once, to improve performance.
					begin
						@response = @request.send(q, 'posts')
						Bib2.log(self, "#{q}: #{@response.size}")
					rescue RequestError => e
						@response = false
						Bib2.log(self, "request failed, #{e}")
					end	
				end
				
				@response
			end
			
		end		
	end
end