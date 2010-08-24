require 'bibmix'

module Bibmix
	
	# The Bibmix::Response class is an abstract class which can be used as a wrapper
	# around a response of a Bibmix::Query.
	class AbstractResponse
		
		# Response status constant for a succesful request/query.
		STATUS_OK = 'status_ok'
		# Response status constant for a failed request/query.
		STATUS_FAIL = 'status_fail'
		
		# The response results are accessable through this array. Items in this array
		# are of type Bibmix::Record.
		attr_reader :result
		
		# Returns an array of Bibmix::Record instances.
		def get
			raise Bibmix::NotImplementedError
		end
		
		# Allows to loop over the contents (Bibmix::Record instances) of the response 
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
			self.get.size
		end
	end
end