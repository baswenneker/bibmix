require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class BibmixTest < ActiveSupport::TestCase
  include Bibmix::Bibsonomy
    
  # Simple test to check if the configuration method returns something.
 	def test_config
 		assert_not_nil(Bibmix::get_config('bibsonomy_api'))
 		assert_equal(false, Bibmix::get_config('some_invalid_key'))
 	end
  
end
