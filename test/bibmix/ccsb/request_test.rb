require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibmix_Ccsb_RequestTest < ActiveSupport::TestCase
  
  def setup
  	@query_title = 'Detecting Content-Bearing Words by Serial Clustering'
 	end
 
 	def test_constructor
 		assert_nothing_raised{
 			request = Bibmix::Ccsb::Request.new()
 		}
 	end
 
 	def test_send
 		
 		request = Bibmix::Ccsb::Request.new()
	
	 	response = nil
 		assert_nothing_raised{
 			response = request.send(@query_title)
 		}
 		
 		assert(response.is_a?(Bibmix::Ccsb::Response))
 	end
end
