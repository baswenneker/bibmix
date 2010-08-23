require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Bib2_CollectedReferenceTest < ActiveSupport::TestCase
  include Bib2
  
	def test_constructor
		reference = Reference.new
		source = 'SomeSource'
		
		assert_nothing_raised{
			CollectedReference.new(reference, source)
		}
		
		assert_raise(Bib2::Error){
			CollectedReference.new(reference, nil)
		}
		assert_raise(Bib2::Error){
			CollectedReference.new(nil, nil)
		}
		assert_raise(Bib2::Error){
			CollectedReference.new(nil, source)
		}
	end
  
end
