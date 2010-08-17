require 'bib2'

module Bib2
	
	# The Bib2::Response class is an abstract class which can be used as a wrapper
	# around a response of a Bib2::Query.
	class Response
		
		# Response status constant for a succesful request/query.
		STATUS_OK = 'status_ok'
		# Response status constant for a failed request/query.
		STATUS_FAIL = 'status_fail'
		
		# The response results are accessable through this array. Items in this array
		# are of type Bib2::Record.
		attr_reader :result
		
		# Returns an array of Bib2::Record instances.
		def get
			raise Bib2::NotImplementedError
		end
		
		# Allows to loop over the contents (Bib2::Record instances) of the response 
		# result.
		def each(&block)
		  self.get.each &block
		end
		
		# Returns the status of the response, STATUS_OK when the response was a success,
		# STATUS_FAIL otherwise.
		def status
			STATUS_OK
		end
		
		# Returns the number items in response result array.
		def size
			raise Bib2::NotImplementedError
		end
	end
end