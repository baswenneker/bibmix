require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module AbstractFilterDecorator
  include Bib2
  
  def teardown
 		@query = nil
 		@reference = nil
 		@collected_references = nil
 		@filter_decorator_class = nil
 		@filter_bonus = nil
 	end
 	  	 
 	# Tests whether the filter actually filters.
 	def test_filter
 		
 		filter = ReferenceFilter.new(@reference)
 		filter = @filter_decorator_class.new(filter)
 		
 		assert_raise(RuntimeError){
 			filter.filter(nil)
 		}
 		
 		filtered_references = nil
 		assert_nothing_raised{
 			filtered_references = filter.filter(@collected_references)
 		}
 		
 		assert(filtered_references.is_a?(Array))
 		assert(filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::FilteredReference) })
 		assert(filter.filtered_references.is_a?(Array))
 		assert(filter.filtered_references.inject(true){|is_a,item| is_a && item.is_a?(Bib2::FilteredReference) })
 		
	end
end