require 'bibmix'

module Bibmix
	
	# A generic abstract class to wrap a request to an API or webservice.
	module RequestAbstract
		
		# An instance variable to store a configuration in.
		attr_reader :config
   	
   	# Abstract method for initializing the configuration in.
   	def init_config
   		raise Bibmix::NotImplementedError
   	end
   
   	# Abstract method for sending the request.
   	def send(*args)
		  raise Bibmix::NotImplementedError
		end		
	end
end