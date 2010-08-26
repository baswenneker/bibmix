require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bibmix_ParscitTest < ActiveSupport::TestCase
  include Bibmix
  
  def setup
  	@citation = 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.'
  end
  
	def test_parse_citation
		
		cme = Parscit.new
		
		reference = nil
		assert_nothing_raised{
			reference = cme.parse_citation(@citation)
		}
		
		assert(reference.kind_of?(Hash))				
		assert_equal(@citation, cme.citation)
		
		citation = 'Zarka Cvetanovic and Dileep Bhandarkar. Characterization of the Alpha AXP Performance Using TP and SPEC Workloads. In Proceedings of the 21st Annual International Symposium on Computer Architecture, pages 60-70, April 1994.'
		reference = cme.parse_citation(citation)
		
	end
end
