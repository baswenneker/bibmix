require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibmix_Bibsonomy_TitleQueryEnrichmentHandlerTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_titlequeryenrichmenthandler
 		
 		record = Bibmix::Reference.from_hash({
 			:citation => 'Parscit An open-source CRF reference string parsing package',
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		
 		handler = TitleQueryEnrichmentHandler.new(record)
 		reference = handler.execute_enrichment_steps()
 	end
end