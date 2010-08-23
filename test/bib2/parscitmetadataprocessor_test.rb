require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bib2_ParscitMetadataProcessorTest < ActiveSupport::TestCase
  include Bib2
  
  def setup
  	@citation = 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.'
  end
  
	def test_parse_citation
		
		cme = Parscit.new
		hash = cme.parse_citation(@citation)
		reference = Bib2::ParscitMetadataProcessor.process_metadata(hash)
		
		assert(reference.kind_of?(Bib2::Reference))
		assert(reference.author.kind_of?(Array))
		assert_equal(3, reference.author.length) 
		assert_equal('ParsCit: An open-source CRF reference string parsing package', reference.title)
	end
end
