require File.expand_path(File.dirname(__FILE__) + "/../../../../../config/environment")
require 'rubygems'
require 'active_support'
require 'active_support/test_case'

module Evaluation
	
	def self.init
		
		line_no = 0
		File.open('cora.txt') {|f| 
			line = f.readline
			
			hash = Reference.create_with_parscit(line).to_hash

			# Convert it to a Bibmix::Record so that it can be merged with data
			# from bibsonomy.
			record = Bibmix::Record.from_hash(hash)
			
	  	@enhanced_record = Bibmix::Bibsonomy::Mixingprocess::Evaluation.new(record).execute
	  	
		}
	end
end

Evaluation.init