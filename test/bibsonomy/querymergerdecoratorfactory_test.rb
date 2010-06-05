require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_QueryMergerTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
  
	def test_decorator_factory
		
		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Record.new
		dummy_query = Query.new
 		
 		# construct the mergers
 		titlemerger = TitleQueryMerger.new(dummy_record, dummy_query)
		
		assert_equal PagesSimilarityDecorator, QueryMergerDecoratorFactory.instance.page(titlemerger).class
		assert_equal TitleSimilarityDecorator, QueryMergerDecoratorFactory.instance.title(titlemerger).class
		assert_equal YearSimilarityDecorator, QueryMergerDecoratorFactory.instance.year(titlemerger).class
		
		assert_equal YearSimilarityDecorator, QueryMergerDecoratorFactory.instance.year_title(titlemerger).class
		assert_equal YearSimilarityDecorator, QueryMergerDecoratorFactory.instance.year_pages(titlemerger).class
		assert_equal YearSimilarityDecorator, QueryMergerDecoratorFactory.instance.year_pages_title(titlemerger).class
	end
  
end
