require 'bibmix'

module Bibmix
	
	class Response
		
		STATUS_OK = 'ok'
		STATUS_FAIL = 'fail'
		
		attr_reader :result
		
		# Returns an array of records from the given xml.
		def get
			raise Bibmix::NotImplementedError
		end
		
		# Allows to loop over the response.
		def each(&block)
		  self.get.each &block
		end
		
		# Returns the status based on the response xml.
		def status
			STATUS_OK
		end
		
		# Returns the number response records.
		def size
			raise Bibmix::NotImplementedError
		end
	end
end