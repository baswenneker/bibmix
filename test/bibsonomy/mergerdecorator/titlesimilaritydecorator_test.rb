require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibsonomy_TitleSimilarityDecoratorTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
   
	# Tests whether the title similarity decorator.
 	def test_similar_titles
 		
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
 		
 		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Record.new
		dummy_query = Query.new
 		
 		# construct the mergers
 		titlemerger = Bibmix::RecordMerger.new(dummy_record, dummy_query)
 		merger = TitleSimilarityDecorator.new(titlemerger)
 		 		
 		assert_equal record1.title.pair_distance_similar(record2.title), (merger.assess_similarity(record1, record2) - titlemerger.assess_similarity(record1, record2))
 		
	end
 
 	# Tests whether the bonus is added when the years are equal in both records.
 	def test_missing_title
 		
 		# set up records
 		record1 = Record.from_hash({
 			:title => 'recorda',
 			:intrahash => 'recorda_hash'
 		}) 

 		record2 = Record.from_hash({
 			:intrahash => 'recordb_hash',
 		})
 		
 		record3 = Record.from_hash({
 			:title => '',
 			:intrahash => 'recordc_hash'
 		})
 		
 		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Record.new
		dummy_query = Query.new
 		
 		# construct the mergers
 		titlemerger = Bibmix::RecordMerger.new(dummy_record, dummy_query)
 		merger = TitleSimilarityDecorator.new(titlemerger)
 		 		
 		merger.assess_similarity(record1, record2)
 		
 	end
 	
end