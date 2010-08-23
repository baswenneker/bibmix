require 'bibmix'

module Bibmix
	module Bibsonomy
		module QueryAbstract
			include Bibmix::ReferenceCollectorAbstract
					
			def initialize			
				@request = Bibmix::Bibsonomy::Request.new
			end

		end
	end
end