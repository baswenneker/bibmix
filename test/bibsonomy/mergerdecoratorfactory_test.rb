require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_MergerDecoratorFactoryTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
  
	def test_decorator_factory
		
		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Record.new
		dummy_query = Query.new
 		
 		# construct the mergers
 		titlemerger = Bibmix::RecordMerger.new(dummy_record, dummy_query)
		
		assert_equal PagesSimilarityDecorator, MergerDecoratorFactory.instance.page(titlemerger).class
		assert_equal TitleSimilarityDecorator, MergerDecoratorFactory.instance.title(titlemerger).class
		assert_equal YearSimilarityDecorator, MergerDecoratorFactory.instance.year(titlemerger).class
		
		assert_equal YearSimilarityDecorator, MergerDecoratorFactory.instance.year_title(titlemerger).class
		assert_equal YearSimilarityDecorator, MergerDecoratorFactory.instance.year_pages(titlemerger).class
		assert_equal YearSimilarityDecorator, MergerDecoratorFactory.instance.year_pages_title(titlemerger).class
	end
  
end
