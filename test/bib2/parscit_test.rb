require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bib2_ParscitTest < ActiveSupport::TestCase
  include Bib2
  
  def setup
  	@citation = 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.'
  end
  
	def test_parse_citation
		
		cme = Parscit.new
		
		reference = nil
		assert_nothing_raised{
			reference = cme.parse_citation(@citation)
		}
		puts reference.to_yaml
		assert(reference.kind_of?(Hash))				
		assert_equal(@citation, cme.citation)
	end
end
