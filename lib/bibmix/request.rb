require 'bibmix'

module Bibmix

	class Request
		attr_reader :config
   	
   	def init_config
   		raise Bibmix::NotImplementedError
   	end
   
   	def send(q='')
		  raise Bibmix::NotImplementedError
		end
		
	end
end