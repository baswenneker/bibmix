require 'bibmix'

module Bibmix
	
	# A generic abstract class to wrap a request to an API or webservice.
	class CacheRequest < Request
		
   	# Abstract method for sending the request.
#   	def send(*args)
#		  result = from_cache(args[0])
#		  
#		  if result.nil?
#		  	puts result = 'no_result'
#		  	
#		  	to_cache(args[0],result)
#		  	
#		  end
#		  
#		  puts result
#		end
		
		def from_cache(name)
			
			begin
				return File.read(get_filepath(name))
			rescue
				return nil
			end
		end
		
		def to_cache(name, contents)
			File.open(get_filepath(name), 'a') {|f| f.write(contents) }
		end
		
		protected
		def get_filepath(name)
			hash = Digest::MD5.hexdigest(name)
			"#{Rails.root}/tmp/cache/request-#{hash}"
		end
	end
end