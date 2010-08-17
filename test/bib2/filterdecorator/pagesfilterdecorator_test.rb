require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Bibsonomy_PagesFilterDecoratorTest < ActiveSupport::TestCase
  include Bib2::Bibsonomy
   
	# Tests whether the bonus is added when the years are equal in both records.
 	def test_similar_year_merging
 		
 		# set up records
 		record1 = Bib2::Reference.from_hash({
 			:title => 'recorda',
 			:intrahash => 'recorda_hash',
 			:pages => '1--2'
 		}) 

 		record2 = Bib2::Reference.from_hash({
 			:title => 'recordb',
 			:intrahash => 'recordb_hash',
 			:pages => '1-2'
 		})
 		
 		record3 = Bib2::Reference.from_hash({
 			:title => 'recordc',
 			:intrahash => 'recordc_hash',
 			:year => '2--1'
 		}) 
 		
 		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Bib2::Reference.new
		dummy_query = Query.new
 		
 		# construct the mergers
 		titlemerger = Bib2::RecordLinker.new(dummy_record, dummy_query)
 		pagesmerger = Bib2::PagesFilterDecorator.new(titlemerger)
 		 		 		
 		assert_equal Bib2::PagesFilterDecorator::SIMILARITY_BONUS, (pagesmerger.assess_similarity(record1, record2) - titlemerger.assess_similarity(record1, record2)).to_f.round(1)
 		assert_equal 0, (pagesmerger.assess_similarity(record1, record3) - titlemerger.assess_similarity(record1, record3)).to_f.round(1)
 		assert_equal 0, (pagesmerger.assess_similarity(record2, record3) - titlemerger.assess_similarity(record2, record3)).to_f.round(1)
 	end
 	
end