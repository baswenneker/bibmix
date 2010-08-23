require 'bibmix'

module Bibmix	
	module MetadataProcessorAbstract
				
		def self.process_metadata(metadata)
			raise Bibmix::NotImplementedError
		end
	
	end
end