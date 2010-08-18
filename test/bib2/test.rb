#require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class XX
	@xx = 1
end

class BibmixTest < ActiveSupport::TestCase
  
    
  # Simple test to check if the configuration method returns something.
 	def test_config
 		puts XX.new.xx
 	end
  
end
