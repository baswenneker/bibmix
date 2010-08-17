require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bib2_Bibsonomy_ChainTest < ActiveSupport::TestCase
  include Bib2::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_authorquery_chain
 		
 		record = Bib2::Reference.from_hash({
 			:title => 'Experimental Test of Parity Conservation in Beta Deca',
 			:author => 'C. S. Wu and E. Ambler and R. W. Hayward and D. D. Hoppes and R. P. Hudson'
 		})
 		chainrecord = Bib2::ChainToken.new(record)
 		
 		#_titlequery_chain(chainrecord, record)
 		
 		#chainrecord = EvaluationChainRecord.new(record)
 		#chainrecord.base_record = record.clone
 		chainrecord = _authorquery_chain(chainrecord, record)
 		
 		
 		#chainrecord.to_excel("#{File.dirname(__FILE__)}/template.xls")
 	end
 
 
 	protected
 	def _authorquery_chain(chainrecord, record)
 		# assert the initial state of the chainrecord
 		assert_equal Bib2::AbstractEnrichmentHandler::STATUS_NOT_MERGED, chainrecord.condition
 		assert_equal record, chainrecord.record
 		
 		# construct the chain
 		
 		author = AuthorQueryEnrichmentHandler.new(Bib2::AbstractEnrichmentHandler::STATUS_NOT_MERGED)
 		
 		# assert the chain
 		
 		assert !author.has_chain
 		
 		# execute the chain of actions.
 		chainrecord = author.execute(chainrecord)
 		
 		#chainrecord.to_excel('test', Bib2.get_config('evaluation_template_xls'))
 		# check the resulting condition
 		assert_equal Bib2::AbstractEnrichmentHandler::STATUS_AUTHOR_MERGED, chainrecord.condition
 		
 		chainrecord
 	end
 	
end