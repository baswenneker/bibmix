require 'bib2'

module Bib2
	module Bibsonomy
		class TitleQuery 
			include QueryAbstract, DesignByContract
			
			pre(	'@request should be a Bib2::RequestAbstract instance') { @request.is_a?(Bib2::RequestAbstract)}
			pre(	'Parameter title should be a Bib2::AbstractReference instance') { |reference| reference.is_a?(Bib2::AbstractReference)}
			post( 'Return value should be an Array of Bib2::CollectedReference instances') { |result, reference| result.is_a?(Array) }
			def collect_references(reference)
				
				begin
					response = @request.send(reference.title, 'posts')
					Bib2.log(self, "'#{reference.title}' response size: #{response.size}")
				rescue RequestError => e
					response = false
					Bib2.log(self, "Request failed, #{e}")
				end	
				
				if response != false
					@response = response.get()
				else
					@response = []
				end
				
				@response
			end
			
		end		
	end
end