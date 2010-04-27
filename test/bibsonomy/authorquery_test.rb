require 'test_helper'

class BibmixBibsonomyAuthorQueryTest < ActiveSupport::TestCase
  
	def setup
    @query = Bibmix::Bibsonomy::AuthorQuery.new
  end  
 
	# Tests whether a search on 'houben' results in something.
 	def test_get_valid_query
 		['houben', 'Geert-Jan Houben', 'Houben, G.J.'].each do |q|
	 		response = nil
	 		assert_nothing_raised{
	 			response = @query.execute(q)
	 		}

	 		assert_not_nil response
	 		assert !response.eql?(false)
	 		assert response.size() > 0
	 		assert !@query.first().eql?(false)
	 		
	 		setup
	 	end
 	end
 	
 	def teardown
 		@query = nil
 	end
 	
end
