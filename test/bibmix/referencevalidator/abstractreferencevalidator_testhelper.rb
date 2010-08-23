require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module AbstractReferenceValidatorTest
  include Bibmix
  
  def teardown
 		@validator_class = nil
 		@implements = nil
 		@valid_reference = nil
 		@invalid_reference = nil
 	end
   
  def test_constructor
 		
 		if @implements.include?(@validator_class::VALIDATE_BOTH)
	 		assert_nothing_raised{
	 			@validator_class.new(@validator_class::VALIDATE_BOTH)
	 		}
 		end
 		
 		if @implements.include?(@validator_class::VALIDATE_ENRICHMENT_REFERENCE)
	 		assert_nothing_raised{
	 			@validator_class.new(@validator_class::VALIDATE_ENRICHMENT_REFERENCE)
	 		}
	 	end
 	
 		if @implements.include?(@validator_class::VALIDATE_CITATION_METADATA)
	 		assert_nothing_raised{
	 			@validator_class.new(@validator_class::VALIDATE_CITATION_METADATA)
	 		}
 		end	
 		
 		assert_raises(Bibmix::Error) {
			@validator_class.new(nil)
		}
		
		assert_raises(Bibmix::Error) {
			@validator_class.new('invalid_condition')
		}
 	end
  
 	def test_handle_validation_request
 		
		@implements.each do |condition|
			validator = @validator_class.new(condition)
		
	 		assert_equal(false, validator.has_next_validator)
	 		
	 		assert_nothing_raised{
	 			validator.handle_validation_request(condition, @valid_reference)
	 		}
		
			assert_raises(Bibmix::ReferenceValidatorError) {
				validator.handle_validation_request(condition, @invalid_reference)
			}
		end
	end
end