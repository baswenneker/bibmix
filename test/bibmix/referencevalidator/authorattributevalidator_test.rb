require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require File.expand_path(File.dirname(__FILE__) + '/abstractreferencevalidator_testhelper.rb')

class Bibmix_AuthorAttributeValidatorTest < ActiveSupport::TestCase
  include AbstractReferenceValidatorTest
  
  def setup
    @validator_class = AuthorAttributeValidator
    
    @implements = [@validator_class::VALIDATE_BOTH]
    
    @valid_reference = Bibmix::Reference.from_hash({
 			:author => 'Japir Bouma and Keith Boot',
 			:year => '2008'
 		})
 		
 		@invalid_reference = Bibmix::Reference.from_hash({
 			:year => '2008'
 		})
  end  
  
end