require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class ChainRecord
			
			attr_accessor :record, :condition
			
			def initialize(record=nil)
				
				@record = record
				self.send("condition=",Chain::STATUS_NOT_MERGED)
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
end