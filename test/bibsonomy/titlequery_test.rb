require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_TitleQueryTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
  
	def setup
    @query = TitleQuery.new
  end  
  
  def teardown
 		@query = nil
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
 		
 		assert_equal false, @query.first()

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

 	
end
