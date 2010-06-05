require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_QueryMergerTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
  
  def setup
  	@querymerger = QueryMerger.new(Record.new, Query.new)
  end
 
  def teardown
  	@querymerger = nil
  end
  
	def test_similar_hashes
		
		hash = {
			:intrahash => '_test_hash_',
			:title => 'testa'
		}
    
    # assess similarity on hash and title 
    record = Record.from_hash(hash)
    assert_equal 1, @querymerger.assess_similarity(record, record)
    
    hash2 = {
			:intrahash => '_test_hash_',
			:title => 'testb'
		}
    
    # assess similarity on the same intrahash
    record2 = Record.from_hash(hash2)
    assert_equal 1, @querymerger.assess_similarity(record, record2)
    
    hash3 = {
			:intrahash => '_test_hashb_',
			:title => 'testb'
		}
    
    # assess similarity on the same title
    record3 = Record.from_hash(hash3)
    assert_equal 1, @querymerger.assess_similarity(record2, record3)
	end
	
	def test_different_hashes
		
		hash1 = {
			:intrahash => '_test_hash_',
			:title => 'testa'
		}
		
		hash2 = {
			:intrahash => 'other_test_hash',
			:title => 'testb'
		}
    
    # asses similarity between two different records
    record1 = Record.from_hash(hash1)
    record2 = Record.from_hash(hash2)
    assert_equal 0, @querymerger.assess_similarity(record1, record2)
	end
  
end
