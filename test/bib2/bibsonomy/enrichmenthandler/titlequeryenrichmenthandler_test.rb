require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bib2_Bibsonomy_TitleQueryEnrichmentHandlerTest < ActiveSupport::TestCase
  include Bib2::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_titlequeryenrichmenthandler
 		
 		record = Bib2::Reference.from_hash({
 			:citation => 'Parscit An open-source CRF reference string parsing package',
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		chainrecord = Bib2::ChainToken.new(record)
 		
 		#_titlequery_chain(chainrecord, record)
 		
 		#chainrecord = EvaluationChainRecord.new(record)
 		#chainrecord.base_record = record.clone
 		chainrecord = _titlequery_chain(chainrecord, record)
 		
 		puts chainrecord.to_yaml
 		#chainrecord.to_excel("#{File.dirname(__FILE__)}/template.xls")
 	end
 	
 	protected
 	def _titlequery_chain(chainrecord, record)
 		# assert the initial state of the chainrecord
 		assert_equal Bib2::AbstractEnrichmentHandler::STATUS_NOT_MERGED, chainrecord.condition
 		assert_equal record, chainrecord.record
 		
 		# construct the chain
 		title = TitleQueryEnrichmentHandler.new(Bib2::AbstractEnrichmentHandler::STATUS_NOT_MERGED)
 		#author = title.chain(AuthorQueryChain.new(Chain::STATUS_AUTHOR_NOT_MERGED))
 		
 		# assert the chain
 		assert !title.has_chain
 		#assert !author.has_chain
 		
 		# execute the chain of actions.
 		chainrecord = title.execute(chainrecord)
 		
 		#chainrecord.to_excel('test', Bib2.get_config('evaluation_template_xls'))
 		# check the resulting condition
 		assert_equal Bib2::AbstractEnrichmentHandler::STATUS_TITLE_MERGED, chainrecord.condition
 		
 		chainrecord
 	end
 	
end