require 'bib2'

module Bib2
	module Bibsonomy
		class AuthorQuery
			include QueryAbstract, DesignByContract
			
			pre(	'@request should be a Bib2::RequestAbstract instance') { @request.is_a?(Bib2::RequestAbstract)}
			pre(	'Parameter title should be a Bib2::AbstractReference instance') { |reference| reference.is_a?(Bib2::AbstractReference)}
			post( 'Return value should be an Array of Bib2::CollectedReference instances') { |result, reference| result.is_a?(Array) && result.inject(true){|is_a,item| is_a && item.is_a?(Bib2::CollectedReference) } }
			def collect_references(reference)
				
				response = []
				reference.author.each do |author_name|
					
					begin
						author_response = @request.send(author_name, 'posts')
						Bib2.log(self, "'#{author_name}' response size: #{author_response.size}")
					rescue RequestError => e
						author_response = false
						Bib2.log(self, "Request failed, #{e}")
					end	
					
					if author_response != false
						response << author_response.get()
					end
				end
				
				@response = response.flatten
			end
			
		end
	end
end