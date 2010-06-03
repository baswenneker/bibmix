require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibmix_Bibsonomy_EvaluationChainRecordTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_chainrecord_condition_setter
 		
 		record = Record.from_hash({
 			:title => 'Experimental Test of Parity Conservation in Beta Deca',
 			:author => 'C. S. Wu and E. Ambler and R. W. Hayward and D. D. Hoppes and R. P. Hudson'
 		})
 		chainrecord = EvaluationChainRecord.new(record)
 		
 		# assert the initial state of the chainrecord
 		assert_equal Chain::STATUS_NOT_MERGED, chainrecord.condition
 		assert_equal record, chainrecord.record
 		assert chainrecord.records[Chain::STATUS_TITLE_MERGED].nil?
 	
 		chainrecord.condition = Chain::STATUS_TITLE_MERGED
 		
 		assert !chainrecord.records[Chain::STATUS_NOT_MERGED].nil?
 		assert !chainrecord.records[Chain::STATUS_TITLE_MERGED].nil?
 		
 end
 	
end