require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bib2_Bibsonomy_TitleQueryEnrichmentHandlerTest < ActiveSupport::TestCase
  include Bib2::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_titlequeryenrichmenthandler
 		
 		record = Bib2::Reference.from_hash({
 			:citation => 'Parscit An open-source CRF reference string parsing package',
 			:title => 'Parscit An open-source CRF reference string parsing package'
 		})
 		
 		handler = TitleQueryEnrichmentHandler.new(record)
 		reference = handler.execute_enrichment_steps()
 		
 		#puts reference.to_yaml
 	end
end