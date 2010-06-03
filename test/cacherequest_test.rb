require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class Bibmix_CacheRequestTest < ActiveSupport::TestCase
  include Bibmix
  
	def setup
    #@query = TitleQuery.new
  end  
  
  def teardown
 		#@query = nil
 	end
 
 	def test_request
 		r = CacheRequest.new
 		
 		r.send('hi')
 	end
 	
end
