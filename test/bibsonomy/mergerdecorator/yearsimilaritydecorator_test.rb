require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibsonomy_YearSimilarityDecoratorTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
   
	# Tests whether the bonus is added when the years are equal in both records.
 	def test_similar_year_merging
 		
 		# set up records
 		record1 = Record.from_hash({
 			:title => 'recorda',
 			:intrahash => 'recorda_hash',
 			:year => '2010'
 		}) 

 		record2 = Record.from_hash({
 			:title => 'recordb',
 			:intrahash => 'recordb_hash',
 			:year => '2010'
 		})
 		
 		record3 = Record.from_hash({
 			:title => 'recordc',
 			:intrahash => 'recordc_hash',
 			:year => '2011'
 		}) 
 		
 		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Record.new
		dummy_query = Query.new
 		
 		# construct the mergers
 		titlemerger = Bibmix::RecordMerger.new(dummy_record, dummy_query)
 		yearmerger = YearSimilarityDecorator.new(titlemerger)
 		 		
 		assert_equal YearSimilarityDecorator::SIMILARITY_BONUS, (yearmerger.assess_similarity(record1, record2) - titlemerger.assess_similarity(record1, record2)).to_f.round(1)
 		assert_equal 0, (yearmerger.assess_similarity(record1, record3) - titlemerger.assess_similarity(record1, record3)).to_f.round(1)
 		assert_equal 0, (yearmerger.assess_similarity(record3, record2) - titlemerger.assess_similarity(record3, record2)).to_f.round(1)
 		
 	end
 
 	def test_int_string_years
 		
 		record1 = Record.from_hash({
 			:title => 'recorda',
 			:intrahash => 'recorda_hash',
 			:year => '2010'
 		}) 

 		record2 = Record.from_hash({
 			:title => 'recordb',
 			:intrahash => 'recordb_hash',
 			:year => 2010
 		})
 		 		 		
 		dummy_record = Record.new
		dummy_query = Query.new
 		
 		titlemerger = Bibmix::RecordMerger.new(dummy_record, dummy_query)
 		yearmerger = YearSimilarityDecorator.new(titlemerger)
 		 		
 		assert_equal YearSimilarityDecorator::SIMILARITY_BONUS, (yearmerger.assess_similarity(record1, record2) - titlemerger.assess_similarity(record1, record2)).round(1)
 		
 	end
 	
end