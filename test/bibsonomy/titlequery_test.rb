require 'test_helper'

class BibmixBibsonomyTitleQueryTest < ActiveSupport::TestCase
  
	def setup
    @query = Bibmix::Bibsonomy::TitleQuery.new
  end  
 	
 	def test_get_invalid_query
 		q = '__invalid_ titlename___'
 		response = nil
 		assert_nothing_raised{
 			response = @query.execute(q)
 		}
 		
 		assert_not_nil response
 		assert !response.eql?(false)
 		assert_equal 0, response.size()
 		
 		assert @query.first().eql?(false)

	end
 
 	def test_get_valid_query
 		q = 'Logsonomy social information retrieval with logdata'
 		response = nil
 		assert_nothing_raised{
 			response = @query.execute(q)
 		}
 		
 		assert_not_nil response
 		assert !response.eql?(false)
 		assert response.size > 0
 		assert !@query.first.eql?(false)
 	end

 	def teardown
 		@query = nil
 	end
end
