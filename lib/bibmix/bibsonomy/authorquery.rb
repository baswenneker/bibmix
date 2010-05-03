require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
			
		class AuthorQuery < Bibmix::Bibsonomy::Query
			
			def execute(author=nil)
				
				if @response.nil?
					
					if !author.kind_of?(String)
						raise InvalidQueryParamError, "Invalid query param (#{author.inspect})."
					end
					
					begin
						@response = @request.send(author, 'posts')
						Rails.logger.info "AuthorQuery::run(#{author}): #{@response.size}"
					rescue RequestError
						@response = false
					end
				end
				
				@response
			end
			
		end
	end
end