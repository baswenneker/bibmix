require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bibmix_PipelineTest < ActiveSupport::TestCase
  include Bibmix
  
  def setup
  	@pipeline = Bibmix::Pipeline.instance 
  	@citation = 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.'
  end
  
  
	def test_parse_citation
		ref = @pipeline.execute_pipeline(@citation)
		
		puts ref.to_yaml
	end
end
