require 'bibmix'

module Bibmix
	
	class MixingProcessError < Bibmix::Error
	end

	class MixingProcessInvariantError < MixingProcessError
	end

	class MixingProcess
		
		attr_reader :base, :current_step, :status
		
		STEP_INIT = 'init'		
		RESULT_NONE = 'no_result'
				
		def initialize(base)
			@current_step = STEP_INIT
			@status = RESULT_NONE
			@base = base
			
			raise MixingProcessInvariantError unless invariant
		end
		
		def execute
			raise Bibmix::NotImplementedError
		end	
		
	protected
		def invariant
			!@base.nil? && @base.class == Bibmix::Record && !@current_step.nil?			
		end
		
	end
end