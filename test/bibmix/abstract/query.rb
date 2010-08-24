require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Bibmix_Abstract_QueryTest 
  
  def setup
  	@query = nil
  	@reference = nil
 		@invalid_reference = nil
  end
  
  def teardown
 		@query = nil
 		@reference = nil
 		@invalid_reference = nil
 	end
  
 	def test_constructor
 		assert_nil(@query.response)
 	end
 	
 	def test_collect_references
 		
 		assert_raise(RuntimeError) {
 			@query.collect_references(nil)
 		}
 		
 		assert_raise(RuntimeError) {
 			@query.collect_references('string')
 		}
 		
 		response = nil
 		assert_nothing_raised{
 			response = @query.collect_references(@reference)
 		}
 		
 		assert(response.kind_of?(Array), 'The response should always be an array')
 		assert(response.size > 0, 'There should be something in the array as there are references found.')
 		assert(response.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::CollectedReference)}, 'All items in the response should be Bibmix::CollectedReference instances.')
 		
 		assert(@query.response.kind_of?(Array), 'The response should always be an array')
 		assert(@query.response.size > 0, 'There should be something in the array as there are references found.')
		assert(@query.response.inject(true){|is_a,item| is_a && item.is_a?(Bibmix::CollectedReference)}, 'All items in the response should be Bibmix::CollectedReference instances.')
		
 		response = nil
 		assert_nothing_raised{
 			response = @query.collect_references(@invalid_reference)
 		}
 		
 		assert(response.kind_of?(Array), 'The response should always be an array')
 		assert_equal(0, response.size, 'There should be nothing in the array as there is nothing found.')
 		
 		assert(@query.response.kind_of?(Array), 'The response should always be an array')
 		assert_equal(0, @query.response.size, 'There should be nothing in the array as there is nothing found.')	
	end
 
end
