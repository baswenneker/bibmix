require 'bib2'

module Bib2	
	module MetadataProcessorAbstract
				
		def self.process_metadata(metadata)
			raise Bib2::NotImplementedError
		end
	
	end
end