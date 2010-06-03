require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class ChainRecord
			
			attr_accessor :record, :condition
			
			def initialize(record=nil)
				
				@record = record
				self.send("condition=",Chain::STATUS_NOT_MERGED)
			end
			
		end
	end
end