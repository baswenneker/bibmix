require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class TitleQuery < Bibmix::Bibsonomy::Query
			
			def execute(q=nil)
				raise Bibmix::QueryError("Invalid query param (#{q}, #{q.class})") unless q.nil? || q.class == String

				if @response.nil?
					# Only do the actual request once, to improve performance.
					begin
						@response = @request.send(q, 'posts')
						Bibmix.log(self, "#{q}: #{@response.size}")
					rescue RequestError => e
						@response = false
						Bibmix.log(self, "request failed, #{e}")
					end	
				end
				
				@response
			end
			
		end		
	end
end