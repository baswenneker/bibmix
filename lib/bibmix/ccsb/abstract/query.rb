require 'bibmix'

module Bibmix
	module Ccsb
		module QueryAbstract
			include Bibmix::ReferenceCollectorAbstract
					
			def initialize			
				@request = Bibmix::Ccsb::Request.new
			end

		end
	end
end