require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibmix_Ccsb_TitleQueryEnrichmentHandlerTest < ActiveSupport::TestCase
  include Bibmix::Ccsb
 
	# Tests a chain which results in a titlequery.
 	def test_titlequeryenrichmenthandler
 		
 		reference = Bibmix::Reference.from_hash({
 			:citation => 'Parscit An open-source CRF reference string parsing package',
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		
 		handler = TitleQueryEnrichmentHandler.new(reference)
 		reference = handler.execute_enrichment_steps()
 		
 		puts reference.to_yaml
 	end
end