require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/abstractfilterdecorator_testhelper.rb')

class Bibmix_PagesFilterDecoratorTest < ActiveSupport::TestCase
  include AbstractFilterDecorator
  
  def setup
    @query = Bibsonomy::TitleQuery.new
    @reference = Bibmix::Reference.from_hash({
 			:title => 'Logsonomy - social information retrieval with logdata',
 			:pages => '2-3'
 		})
 		@collected_references = [
 			Bibmix::CollectedReference.new(Bibmix::Reference.from_hash({
	 			:title => 'test1',
	 			:series => 'series1',
	 			:pages => '2--3',
	 			:intrahash => 'id1'
	 		}), 'unknown source'),
	 		Bibmix::CollectedReference.new(Bibmix::Reference.from_hash({
	 			:title => 'test2',
	 			:series => 'series2',
	 			:pages => '3-4',
	 			:intrahash => 'id2'
	 		}), 'unknown source'),
 		]
 		@filter_decorator_class = Bibmix::PagesFilterDecorator
 		@filter_bonus = Bibmix::PagesFilterDecorator::SIMILARITY_BONUS
  end  
  
 	# Tests whether the filter actually filters.
 	def test_filter_bonus
 		
 		filter = ReferenceFilter.new(@reference)
 		filter = @filter_decorator_class.new(filter)
 		
 		filtered_references = filter.filter(@collected_references)
 		
 		assert(filtered_references.is_a?(Array))
 		assert(filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::FilteredReference) })
 		
 		filtered_references.each do |filtered_ref|
 			if filtered_ref.reference.pages == @reference.pages
 				assert_equal(@filter_bonus, filtered_ref.relevance)
 				assert_equal('id1', filtered_ref.reference.id)
 			else
 				assert_equal(0, filtered_ref.relevance)
 				assert_equal('id2', filtered_ref.reference.id)
 			end
 		end
 	end
end
#require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')
#
#class Bibsonomy_PagesFilterDecoratorTest < ActiveSupport::TestCase
#  include Bibmix::Bibsonomy
#   
#	# Tests whether the bonus is added when the years are equal in both records.
# 	def test_similar_year_merging
# 		
# 		# set up records
# 		record1 = Bibmix::Reference.from_hash({
# 			:title => 'recorda',
# 			:intrahash => 'recorda_hash',
# 			:pages => '1--2'
# 		}) 
#
# 		record2 = Bibmix::Reference.from_hash({
# 			:title => 'recordb',
# 			:intrahash => 'recordb_hash',
# 			:pages => '1-2'
# 		})
# 		
# 		record3 = Bibmix::Reference.from_hash({
# 			:title => 'recordc',
# 			:intrahash => 'recordc_hash',
# 			:year => '2--1'
# 		}) 
# 		
# 		# use these dummy objects for the instantiation of the titlemerger.
# 		dummy_record = Bibmix::Reference.new
#		dummy_query = Query.new
# 		
# 		# construct the mergers
# 		titlemerger = Bibmix::RecordLinker.new(dummy_record, dummy_query)
# 		pagesmerger = Bibmix::PagesFilterDecorator.new(titlemerger)
# 		 		 		
# 		assert_equal Bibmix::PagesFilterDecorator::SIMILARITY_BONUS, (pagesmerger.assess_similarity(record1, record2) - titlemerger.assess_similarity(record1, record2)).to_f.round(1)
# 		assert_equal 0, (pagesmerger.assess_similarity(record1, record3) - titlemerger.assess_similarity(record1, record3)).to_f.round(1)
# 		assert_equal 0, (pagesmerger.assess_similarity(record2, record3) - titlemerger.assess_similarity(record2, record3)).to_f.round(1)
# 	end
# 	
#end