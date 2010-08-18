require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bib2_FilteredReferenceTest < ActiveSupport::TestCase
  include Bib2
  
	def test_constructor
		reference = Reference.new
		source = 'SomeSource'
		collected_reference = CollectedReference.new(reference, source)
		
		assert_nothing_raised {
			FilteredReference.new(collected_reference, 1.0)
		}
				
		assert_raise(Bib2::Error){
			FilteredReference.new(collected_reference, nil)
		}
		assert_raise(Bib2::Error){
			FilteredReference.new(collected_reference, 1)
		}		
		assert_raise(Bib2::Error){
			CollectedReference.new(nil, nil)
		}
		assert_raise(Bib2::Error){
			CollectedReference.new(nil, 1.0)
		}
	end
  
end
