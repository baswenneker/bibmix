require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_FilterDecoratorFactoryTest < ActiveSupport::TestCase
  include Bibmix
  
	def test_decorator_factory
		
		# use these dummy objects for the instantiation of the titlemerger.
 		dummy_record = Reference.new
 		
 		# construct the mergers
 		titlemerger = Bibmix::ReferenceFilter.new(dummy_record)
		
		assert_equal PagesFilterDecorator, FilterDecoratorFactory.instance.page(titlemerger).class
		assert_equal TitleFilterDecorator, FilterDecoratorFactory.instance.title(titlemerger).class
		assert_equal YearFilterDecorator, FilterDecoratorFactory.instance.year(titlemerger).class
		
		assert_equal YearFilterDecorator, FilterDecoratorFactory.instance.year_title(titlemerger).class
		assert_equal YearFilterDecorator, FilterDecoratorFactory.instance.year_pages(titlemerger).class
		assert_equal YearFilterDecorator, FilterDecoratorFactory.instance.year_pages_title(titlemerger).class
	end
  
end
