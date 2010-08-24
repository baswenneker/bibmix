require 'bibmix'

module Bibmix
	module Ccsb
		class TitleQuery 
			include Bibmix::Ccsb::QueryAbstract, DesignByContract
			
			pre(	'@request should be a Bibmix::RequestAbstract instance') { @request.is_a?(Bibmix::RequestAbstract)}
			pre(	'Parameter reference should be a Bibmix::AbstractReference instance') { |reference| reference.is_a?(Bibmix::AbstractReference)}
			post( 'Return value should be an Array of Bibmix::CollectedReference instances') { |result, reference| result.is_a?(Array) }
			def collect_references(reference)
				
				begin
					response = @request.send(reference.title)
					Bibmix.log(self, "'#{reference.title}' response size: #{response.size}")
				rescue RequestError => e
					response = false
					Bibmix.log(self, "Request failed, #{e}")
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