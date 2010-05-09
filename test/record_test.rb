require 'test_helper'
require 'bibmix'

class BibmixRecordTest < ActiveSupport::TestCase
  
  def setup
  	@hash = get_hash
  	
		@record = Bibmix::Record.from_hash(@hash)
  end
 
	def test_each_attribute	
		@record.each_attribute do |k|
			assert @record.get_attributes.include?(k)
		end		
	end
  
	def test_from_hash
		
    record = Bibmix::Record.from_hash(@hash)
    
		@hash.each do |k, v|			
			if record.get_attributes.include?(k)
				assert_not_nil record.send("#{k}")
			end
		end
		
		assert record.author.kind_of?(Array)
	end
	
	def test_invalid_merge
		
		assert_raise(Bibmix::RecordInvalidMergeParamError){
			@record.merge(nil)
		}
		
		assert_raise(Bibmix::RecordInvalidMergeParamError){
			@record.merge(@hash)
		}
		
	end
	
	def test_merge
		
    merge_hash = get_merge_hash
    merge_record = Bibmix::Record.from_hash(merge_hash)
		
		@record.merge(merge_record)
		
		@hash.each do |k, v|
		 puts k
			if k == :author
				assert_not_nil @record.fetch(k)
			elsif k == :location
				# location is an invalid key not present in the record.
				assert_nil @record.fetch(k)
			else
				assert_not_nil @record.fetch(k)
				assert_equal v, @record.fetch(k)
			end
		end
		
		assert_equal merge_hash[:publisher], @record.fetch('publisher')
		assert_equal @hash[:year], @record.fetch('year')
		
	end
	
	def teardown
		@record = nil
		@hash = nil
	end
	
	protected
  def get_hash
  	hash = {
  		:citation => 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.',
  		:author => 'Isaac G Councill and C Lee Giles and Min-Yen Kan',
  		:title => 'Parscit An open-source CRF reference string parsing package',
  		:year => '2008',
  		:location => 'Marrakesh, Morrocco',
  		:booktitle => 'in the proceedings of the Language Resources and Evaluation Conference (LREC 08'
  	}
 	end
 
	def get_merge_hash
  	hash = {
  		:publisher => 'ACM',
  		:year => '2010'
  	}
  end
  
end
