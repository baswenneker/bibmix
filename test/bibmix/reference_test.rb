require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'bibtex'

class Bibmix_ReferenceTest < ActiveSupport::TestCase
  include Bibmix
  
  def setup
  	@hash = get_hash
  	@reference = Reference.from_hash(@hash)
  	collected_reference = CollectedReference.new(@reference, 'unknown source')
  	@filtered_reference = FilteredReference.new(collected_reference, 1.0)
  	
  	@merge_hash = get_merge_hash
  	@merge_reference = Reference.from_hash(@merge_hash)
  	collected_reference = CollectedReference.new(@merge_reference, 'unknown source')
  	@merge_filtered_reference = FilteredReference.new(collected_reference, 1.0)
  end
 
	def test_each_attribute
		@reference.each_attribute do |k|
			assert @reference.get_attributes.include?(k)
		end		
	end
	
	def test_merged_attribute
			
		@reference.merge(@merge_filtered_reference)
		assert @reference.merged
		
		# set merged to false and check if the correct value is stored
		@reference.merged = false
		assert_equal(false, @reference.merged)
		
		# there is nothing to merge, so merged should still be false
		@reference.merge(@merge_filtered_reference)
		assert_equal(false, @reference.merged)
	end
  
  def test_from_bibtex
  	bibtex_str = 
  		'@InProceedings{sigir95,
			  author =	"A. Bookstein and S. T. Klein and T. Raita",
			  title =	"Detecting Content-Bearing Words by Serial Clustering",
			  pages =	"319--327",
			  ISBN = 	"0-89791-714-2",
			  editor =	"Edward A. Fox and Peter Ingwersen and Raya Fidel",
			  booktitle =	"Proceedings of the 18th Annual International
					 Conference on Research and Development in Information
					 Retrieval (SIGIR95)",
			  month =	jul,
			  publisher =	"ACM Press",
			  address =	"New York, NY, USA",
			  year = 	"1995"
			}'
			
		result = nil
		Bibtex::Parser.parse_string(bibtex_str).map do |entry|
		  result = entry
		end
		
		Reference.from_bibtex(result)    
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
		assert_raise(Bibmix::ReferenceInvalidMergeParamError){
			@record.merge(nil)
		}
		
		assert !@record.merged
		
		assert_raise(Bibmix::ReferenceInvalidMergeParamError){
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
		
		assert_raise(Bibmix::ReferenceError){
			record.tags = 'some_invalid_tag_type'
		}		
	end

	def test_merge
		
		assert_nothing_raised{
    	@reference.merge(@merge_filtered_reference)
    }
		
		@hash.each do |k, v|
			if k == :author
				assert_not_nil @reference.get(k)
			else
				assert_not_nil @reference.get(k)
				assert_equal v, @reference.get(k)
			end
		end
		
		assert_equal @merge_hash[:publisher], @reference.get('publisher')
		assert_equal @hash[:year], @reference.get('year')
		
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
