require 'bibmix'

module Bibmix
	class ChainToken
		
		attr_accessor :reference, :condition
		
		def initialize(reference=nil)
			
			@reference = reference
			#self.send("condition=",AbstractEnrichmentHandler::STATUS_NOT_MERGED)
		end
		
		def set_merged_record(record, status_merged, status_not_merged)
			
			@record = record
			
			if record.merged == true
				self.send("condition=", status_merged)
				Bibmix.log(self, 'successfully merged title, setting chainrecord condition to STATUS_TITLE_MERGED')
			else
				self.send("condition=", status_not_merged)
				Bibmix.log(self, 'didn\'t merge record (probably no new values/attributes), setting chainrecord condition to STATUS_TITLE_MERGED')
			end
							
		end
		
	end
end