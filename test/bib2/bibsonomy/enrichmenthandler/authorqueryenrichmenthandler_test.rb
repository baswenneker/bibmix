require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bib2_Bibsonomy_AuthorQueryEnrichmentHandlerTest < ActiveSupport::TestCase
  include Bib2::Bibsonomy
 
	# Tests a chain which results in a titlequery.
 	def test_titlequeryenrichmenthandler
 		
 		reference = Bib2::Reference.from_hash({
 			:title => 'Experimental Test of Parity Conservation in Beta Deca',
 			:author => 'C. S. Wu and E. Ambler and R. W. Hayward and D. D. Hoppes and R. P. Hudson'
 		})
 		
 		handler = AuthorQueryEnrichmentHandler.new(reference)
 		reference = handler.execute_enrichment_steps()
 		
 		puts reference.to_yaml
 	end
end