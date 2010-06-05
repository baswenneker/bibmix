require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibmix_Bibsonomy_ChainTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_titlequery_chain
 		
 		record = Record.from_hash({
 			:citation => 'Parscit An open-source CRF reference string parsing package',
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		chainrecord = ChainRecord.new(record)
 		
 		#_titlequery_chain(chainrecord, record)
 		
 		chainrecord = EvaluationChainRecord.new(record)
 		chainrecord.base_record = record.clone
 		chainrecord = _titlequery_chain(chainrecord, record)
 		
 		#chainrecord.to_excel("#{File.dirname(__FILE__)}/template.xls")
 	end
 	
 	# Tests a chain which results in a authorquery.
 	def _test_authorquery_chain
 
 		record = Record.from_hash({
 			:title => 'Experimental Test of Parity Conservation in Beta Deca',
 			:author => 'C. S. Wu and E. Ambler and R. W. Hayward and D. D. Hoppes and R. P. Hudson'
 		})
 		chainrecord = ChainRecord.new(record)
 		
 		# assert the initial state of the chainrecord
 		assert_equal Chain::STATUS_NOT_MERGED, chainrecord.condition
 		assert_equal record, chainrecord.record
 		
 		# construct the chain
 		title = TitleQueryChain.new(Chain::STATUS_NOT_MERGED)
 		author = title.chain(AuthorQueryChain.new(Chain::STATUS_TITLE_NOT_MERGED))
 		
 		# assert the chain
 		assert title.has_chain
 		assert !author.has_chain
 		
 		# execute the chain of actions.
 		chainrecord = title.execute(chainrecord)
 		
 		# check the resulting condition
 		assert_equal Chain::STATUS_AUTHOR_MERGED, chainrecord.condition
 	end
 
 	# Tests a chain which results in a authorquery.
 	def _test_forbidden_authorquery_chain
 		
 		record = Record.from_hash({
 			:citation => 'Experimental Test of Parity Conservation in Beta Deca',
 			:title => 'Experimental Test of Parity Conservation in Beta Deca',
 			:author => 'C. S. Wu and E. Ambler and R. W. Hayward and D. D. Hoppes and R. P. Hudson'
 		})
 		chainrecord = ChainRecord.new(record)
 		 		
 		# construct the chain
 		title = TitleQueryChain.new(Chain::STATUS_NOT_MERGED)
 		title.chain(AuthorQueryChain.new(Chain::STATUS_TITLE_MERGED))
 		
 		# execute the chain of actions.
 		chainrecord = title.execute(chainrecord)
 		
 		# check the resulting condition
 		assert_equal Chain::STATUS_TITLE_NOT_MERGED, chainrecord.condition
 	end
 
 	protected
 	def _titlequery_chain(chainrecord, record)
 		# assert the initial state of the chainrecord
 		assert_equal Chain::STATUS_NOT_MERGED, chainrecord.condition
 		assert_equal record, chainrecord.record
 		
 		# construct the chain
 		title = TitleQueryChain.new(Chain::STATUS_NOT_MERGED)
 		author = title.chain(AuthorQueryChain.new(Chain::STATUS_AUTHOR_NOT_MERGED))
 		
 		# assert the chain
 		assert title.has_chain
 		assert !author.has_chain
 		
 		# execute the chain of actions.
 		chainrecord = title.execute(chainrecord)
 		
 		puts chainrecord.to_yaml
 		chainrecord.to_excel('test',"#{File.dirname(__FILE__)}/template.xls")
 		# check the resulting condition
 		assert_equal Chain::STATUS_TITLE_MERGED, chainrecord.condition
 		
 		chainrecord
 	end
 	
end