require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bib2_ReferenceTest < ActiveSupport::TestCase
  include Bib2
  
  def setup
  	@hash = get_hash
  end
 
	def test_each_attribute
		@record = Reference.from_hash(@hash)
		@record.each_attribute do |k|
			assert @record.get_attributes.include?(k)
		end		
	end
	
	def test_merged_attribute
		merge_hash = get_merge_hash
    merge_record = Reference.from_hash(merge_hash)
    
    # merge a record and check if the record was merged
		@record = Reference.from_hash(get_hash)
		@record.merge(merge_record)
		assert @record.merged
		
		# set merged to false and check if the correct value is stored
		@record.merged = false
		assert_equal false, @record.merged
		
		# there is nothing to merge, so merged should still be false
		@record.merge(merge_record)
		assert_equal false, @record.merged
	end
  
	def test_from_hash
		
    @record = Reference.from_hash(@hash)    
		@hash.each do |k, v|			
			if @record.get_attributes.include?(k)
				assert_not_nil @record.send("#{k}")
			end
		end	
		
		assert @record.author.kind_of?(Array)
	end

	def test_invalid_merge
		
		@record = Reference.from_hash(@hash)    
		assert_raise(Bib2::ReferenceInvalidMergeParamError){
			@record.merge(nil)
		}
		
		assert !@record.merged
		
		assert_raise(Bib2::ReferenceInvalidMergeParamError){
			@record.merge(@hash)
		}
		
		assert !@record.merged
		
	end
	
	def test_author_setter
		
		record = Reference.new		
		record.author = 'A and B'
		
		assert_equal Array, record.author.class
		assert_equal 'A', record.author[0]
		assert_equal 'B', record.author[1]
		
		record.author = ['A', 'B']
		
		assert_equal Array, record.author.class
		assert_equal 'A', record.author[0]
		assert_equal 'B', record.author[1]
	end
	
	def test_tags_setter
		
		record = Reference.new		
		record.tags = {
			:x => 'a',
			:y => 'b'
		}
		
		assert_equal Hash, record.tags.class
		
		assert_raise(Bib2::ReferenceError){
			record.tags = 'some_invalid_tag_type'
		}		
	end

	def test_merge
		
    merge_hash = get_merge_hash
    merge_record = Reference.from_hash(merge_hash)
		@record = Reference.from_hash(get_hash)
		@record.merge(merge_record)
		
		@hash.each do |k, v|
			if k == :author
				assert_not_nil @record.get(k)
			else
				assert_not_nil @record.get(k)
				assert_equal v, @record.get(k)
			end
		end
		
		assert_equal merge_hash[:publisher], @record.get('publisher')
		assert_equal @hash[:year], @record.get('year')
		
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
  		:address => 'Marrakesh, Morrocco',
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
