require 'test_helper'
require 'bibmix/bibsonomy'

class BibmixBibsonomyRequestTest < ActiveSupport::TestCase
  
	def setup
    @request = Bibmix::Bibsonomy::Request.new
  end
  
  def test_configuration  	
  	
  	assert File::exists?(Bibmix::Bibsonomy::Request::DEFAULT_CONFIG)
  	assert_not_nil @request.config
  	assert_not_nil @request.config['username']
  	assert_not_nil @request.config['api_key']
  	assert_not_nil @request.config['format']
		
		assert !File::exists?('invalid___FILE')
  	assert_raise(Bibmix::Bibsonomy::InvalidRequestConfigFileError){
  		r = Bibmix::Bibsonomy::Request.new
  		r.init_config('invalid___FILE')
  	}
  	
 	end
 	
 	
  def test_constructor
  	assert_nothing_raised{
  		Bibmix::Bibsonomy::Request.new
  	}
  end
 
 	def test_posts_request_response
 		q = 'Logsonomy - social information retrieval with logdata'
 		response = nil
 		assert_nothing_raised{
 			response = @request.send(q, 'posts')
 		}
 	end
 
 	def test_query_preprocessing
 		q = 'Logsonomy - social information retrieval with logdata'
 		p = @request.preprocess_query(q)
  	 		
 		assert q =~ /-/
 		
 		assert_not_nil p
 		assert p !=~ /-/
 	end
 	
end
