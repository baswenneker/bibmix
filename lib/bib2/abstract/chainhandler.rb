
module Bib2
	class AbstractChainHandler
		@chained_handler = nil
		@chain_condition = nil
		
		def initialize(chain_condition)
			@chain_condition = chain_condition
		end
		
		def chain(chain_instance)
			@chained_handler = chain_instance
		end
		
		def has_chain
			not @chained_handler.nil?
		end
		
		def execute(record)
			
			if @chain_condition <= record.condition
				record = execute_chain_action(record)
			end
			
			if has_chain
				record = @chained_handler.execute(record)
			end
			
			record
		end
		
		protected
		def execute_chain_action(record)
			raise Bib2::NotImplementedError
		end
	end
end