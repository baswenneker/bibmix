require 'test_helper'
require 'bibmix'

class BibmixRecordTest < ActiveSupport::TestCase
  
  def setup
  	@hash = {
  		:citation => 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.',
  		:author => 'Isaac G Councill and C Lee Giles and Min-Yen Kan',
  		:title => 'Parscit An open-source CRF reference string parsing package',
  		:year => '2008',
  		:location => 'Marrakesh, Morrocco',
  		:booktitle => 'in the proceedings of the Language Resources and Evaluation Conference (LREC 08'
  	}
  	
		@record = Bibmix::Record.from_hash(@hash)
  end
 
	def test_each_attribute	
		@record.each_attribute do |k|
			assert @record.get_attributes.include?(k)
		end		
	end
  
	def test_from_hash
		
    assert_not_nil @record
    
		@hash.each do |k, v|			
			if @record.get_attributes.include?(k)
				assert_not_nil @record.send("#{k}")
			end
		end
		
		assert @record.author.kind_of?(Array)
	end
	
	def teardown
		@record = nil
		@hash = nil
	end
  
end
