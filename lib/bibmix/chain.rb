
module Bibmix
	class Chain
		@chain_instance = nil
		@chain_condition = nil
		
		def initialize(chain_condition)
			@chain_condition = chain_condition
		end
		
		def chain(chain_instance)
			@chain_instance = chain_instance
		end
		
		def has_chain
			not @chain_instance.nil?
		end
		
		def execute(record)
			
			if @chain_condition <= record.condition
				record = execute_chain_action(record)
			end
			
			if has_chain
				record = @chain_instance.execute(record)
			end
			
			record
		end
		
		protected
		def execute_chain_action(record)
			raise Bibmix::NotImplementedError
		end
	end
end