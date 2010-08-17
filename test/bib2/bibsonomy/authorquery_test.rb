require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibsonomy_AuthorQueryTest < ActiveSupport::TestCase
  include Bib2
  
	def setup
    @query = Bibsonomy::AuthorQuery.new
  end
  
 	def teardown
 		@query = nil
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
 	
end