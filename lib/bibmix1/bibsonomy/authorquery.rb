require 'bibmix'

module Bibmix
	module Bibsonomy
		class AuthorQuery
			include QueryAbstract, DesignByContract
			
			pre(	'@request should be a Bibmix::RequestAbstract instance') { @request.is_a?(Bibmix::RequestAbstract)}
			pre(	'Parameter title should be a Bibmix::AbstractReference instance') { |reference| reference.is_a?(Bibmix::AbstractReference)}
			post( 'Return value should be an Array of Bibmix::CollectedReference instances') { |result, reference| result.is_a?(Array) && result.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::CollectedReference) } }
			def collect_references(reference)
				
				response = []
				reference.author.each do |author_name|
					
					begin
						author_response = @request.send(author_name, 'posts')
						Bibmix.log(self, "'#{author_name}' response size: #{author_response.size}")
					rescue RequestError => e
						author_response = false
						Bibmix.log(self, "Request failed, #{e}")
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