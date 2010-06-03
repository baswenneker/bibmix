require 'bibmix/bibsonomy'

module Bibmix
	module Bibsonomy
		class Chain < Bibmix::Chain
			
			STATUS_NOT_MERGED = 1
			STATUS_TITLE_NOT_MERGED = 2
			STATUS_TITLE_MERGED = 3
			STATUS_AUTHOR_NOT_MERGED = 4
			STATUS_AUTHOR_MERGED = 5
			
			def execute(record)
				self.log("chain condition = #{Chain.status_to_s(@chain_condition)} <= #{Chain.status_to_s(record.condition)}")
				super(record)
			end
			
			def log(message)
				Bibmix.log(self, message)
			end
			
			def self.status_hash
				
				if @_status_hash.nil?
					@_status_hash = {}
					self.constants.each do |const|
						@_status_hash[const] = self.const_get(const)						
					end
				end
				
				@_status_hash
			end
			
			def self.status_to_s(status)
				self.status_hash.invert[status]
			end			
		end
	end
end