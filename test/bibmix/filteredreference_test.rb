require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bibmix_FilteredReferenceTest < ActiveSupport::TestCase
  include Bibmix
  
	def test_constructor
		reference = Reference.new
		source = 'SomeSource'
		collected_reference = CollectedReference.new(reference, source)
		
		assert_nothing_raised {
			FilteredReference.new(collected_reference, 1.0)
		}
				
		assert_raise(Bibmix::Error){
			FilteredReference.new(collected_reference, nil)
		}
		assert_raise(Bibmix::Error){
			FilteredReference.new(collected_reference, 1)
		}		
		assert_raise(Bibmix::Error){
			CollectedReference.new(nil, nil)
		}
		assert_raise(Bibmix::Error){
			CollectedReference.new(nil, 1.0)
		}
	end
  
end
