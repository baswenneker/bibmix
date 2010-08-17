require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_ReferenceLinkerTest < ActiveSupport::TestCase
  include Bib2
  
  def setup
  	@querymerger = Bib2::RecordLinker.new(Reference.new, Bibsonomy::Query.new)
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
    record = Reference.from_hash(hash)
    assert_equal 1, @querymerger.assess_similarity(record, record)
    
    hash2 = {
			:intrahash => '_test_hash_',
			:title => 'testb'
		}
    
    # assess similarity on the same intrahash
    record2 = Reference.from_hash(hash2)
    assert_equal 1, @querymerger.assess_similarity(record, record2)
    
    hash3 = {
			:intrahash => '_test_hashb_',
			:title => 'testb'
		}
    
    # assess similarity on the same title
    record3 = Reference.from_hash(hash3)
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
    record1 = Reference.from_hash(hash1)
    record2 = Reference.from_hash(hash2)
    assert_equal 0, @querymerger.assess_similarity(record1, record2)
	end
  
end
