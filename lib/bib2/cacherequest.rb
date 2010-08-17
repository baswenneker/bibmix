require 'bib2'

module Bib2
	
	# A generic abstract class to wrap a request to an API or webservice.
	class CacheRequest < AbstractRequest
		
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